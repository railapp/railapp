# Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
# Copyright:: Copyright (c) 2006-2008 Joel Parker Henderson
# License:: CreativeCommons License, Non-commercial Share Alike
# License:: LGPL, GNU Lesser General Public License

class Object

  # Sugar to let us write:
  #   object.in? array
  # Identical to:
  #   array.include? object
  def in?(array)
    array.include?(self)
  end
  
end