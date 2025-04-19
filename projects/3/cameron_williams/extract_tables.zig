const std = @import("std");

const c = @cImport({
    @include("libxml/parser.h");
    @include("libxml/tree.h");
});

const fs = std.fs;
const allocator = std.heap.page_allocator;

fn handle_error(msg: []const u8) void {
    const stderr = std.io.getStdErr().writer();
    _ = stderr.print("ERROR: {}\n", .{msg});
}

fn node_to_text(node: *c.xmlNodePtr) []const u8 {
    const content = c.xmlNodeGetContent(node);
    if (content == null) return "";
    const text = std.mem.cast([*]u8, content);
    c.xmlFree(content);
    return text;
}

fn extract_tables(file: []const u8) !void {
    const f = try fs.openFile(file, .{ .read = true });
    defer f.close();

    const content = try f.readToEndAlloc(allocator, 1024);
    defer allocator.free(content);

    const doc = c.htmlParseDoc(content, null);
    if (doc == null) return null;
    defer c.xmlFreeDoc(doc);

    var node = c.xmlDocGetRootElement(doc);
    var count = 0;

    while (node != null) {
        if (node.*.type == c.XML_ELEMENT_NODE and std.mem.eql(u8, node.*.name, "table")) {
            count += 1;
            var csv = "";
            var row = node;
            while (row != null) {
                if (row.*.type == c.XML_ELEMENT_NODE and std.mem.eql(u8, row.*.name, "tr")) {
                    var cell = row.*.children;
                    var row_csv = "";
                    while (cell != null) {
                        if (cell.*.type == c.XML_ELEMENT_NODE and (std.mem.eql(u8, cell.*.name, "td") or std.mem.eql(u8, cell.*.name, "th"))) {
                            row_csv += node_to_text(cell) ++ ",";
                        }
                        cell = cell.*.next;
                    }
                    csv += row_csv + "\n";
                }
                row = row.*.next;
            }
            const name = "table_" + std.fmt.allocPrint(allocator, "{}.csv", .{count}) catch return null;
            const out = try fs.createFile(name, .{ .write = true });
            defer out.close();
            try out.writeAll(csv);
        }
        node = node.*.next;
    }
}

pub fn main() void {
    const args = std.process.argv();
    if (args.len != 2) {
        handle_error("Usage: <html_file>");
        return;
    }

    const file = args[1];
    const result = extract_tables(file);
    if (result) |err| {
        handle_error("Error: {}\n", .{err});
    }
}
