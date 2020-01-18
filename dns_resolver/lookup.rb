def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

# ..
# parse_dns method for sorting the respective records
def parse_dns(raw_data)
  records = { "A" => {}, "CNAME" => {} }
  raw_data.each do |line|
    array = line.strip.split(", ")
    if array.first.eql? "A"
      records["A"][array[1]] = array[2]
    else
      records["CNAME"][array[1]] = array[2]
    end
  end
  records
end

# resolve method for chain up the domain links
def resolve(records, chain, domain)
  if records["A"].keys.include? domain
    chain << records["A"][domain]
  elsif records["CNAME"].keys.include? domain
    chain << records["CNAME"][domain]
    resolve(records, chain, records["CNAME"][domain])
  else
    chain << "Error: record not found for #{domain}"
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
