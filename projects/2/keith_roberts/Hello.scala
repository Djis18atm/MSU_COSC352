object Hello {
  def main(args: Array[String]): Unit = {
    if (args.length == 2) {
      val name = args(0)
      val num = args(1).toInt
      for (i <- 1 to num)
        println(s"Hello, $name!")
    }
  }
}