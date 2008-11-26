# Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
# Copyright:: Copyright (c) 2006-2008 Joel Parker Henderson
# License:: CreativeCommons License, Non-commercial Share Alike
# License:: LGPL, GNU Lesser General Public License
#
# MultiHash lets you do on-the-fly creation of deep hashes
#
# Example:
#   h = MultiHash.new
#   h[:x][:y][:z] = 123
##

class MultiHash < Hash
  def initialize
    super{|h,k| h[k] = MultiHash.new }
  end
end
