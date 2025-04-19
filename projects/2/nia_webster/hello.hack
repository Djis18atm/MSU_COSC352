<?hh

<<__EntryPoint>>
function main(): void {
  $args = \HH\global_get('argv');

  if (count($args) < 2) {
    echo "Usage: hhvm hello.hack <name> [number]\n";
    return;
  }

  $name = $args[1];
  $times = $args[2] ?? '1'; // Default to 1 if not provided

  // Ensure $times is a valid positive integer
  if (!ctype_digit($times)) {
    echo "Please provide a valid positive number for repetitions.\n";
    return;
  }

  for ($i = 0; $i < (int)$times; $i++) {
    echo "Hello {$name}\n";
  }
}
