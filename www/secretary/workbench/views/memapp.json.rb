# parse and return the contents of the latest memapp-received file

# find latest memapp-received.txt file in the foundation/Meetings directory
meetings = ASF::SVN['private/foundation/Meetings']
received = Dir["#{meetings}/2*/memapp-received.txt"].sort.last.untaint

# extract contents
pattern = /^\w+\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(.*)\n/
table = File.read(received).scan(pattern)

# map contents to a hash
fields = %w(apply mail karma id name)
{received: table.map {|results| fields.zip(results).to_h}}
