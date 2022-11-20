require_relative "lib/web_search"

web_search = WebSearch.new
web_search.read_input("public/input.txt")
web_search.export_output("public/output.txt")
