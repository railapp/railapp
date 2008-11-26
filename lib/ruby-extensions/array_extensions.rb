# Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
# Copyright:: Copyright (c) 2006-2008 Joel Parker Henderson
# License:: CreativeCommons License, Non-commercial Share Alike
# License:: LGPL, GNU Lesser General Public License

class Array

 # Return the union of the array's items.
 # In typical use, each item is an array.
 # E.g. foos.map(&:bars).union => bars in any foo

 def union
  inject([]){|inj,x| inj | x.to_a }
 end


 # Return the intersection of the array's items.
 # In typical usage, each item is an array.
 # E.g. foos.map(&:bars).intersect => bars in all foos

 def intersect
  inject([]){|inj,x| inj & x.to_a }
 end


end
