# Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
# Copyright:: Copyright (c) 2006-2008 Joel Parker Henderson
# License:: CreativeCommons License, Non-commercial Share Alike
# License:: LGPL, GNU Lesser General Public License

module Enumerable


  def map_id
    map{|x| x.id}
  end


  def map_to_sym
    map{|x| x.to_sym}
  end


  # enum.select_while {|obj| block } => array
  # Returns an array containing the leading elements for which block is not false or nil.
  def select_while
    a = []
    each{|x| yield(x) ? (a << x) : break}
    return a
  end


  # enum.select_until {|obj| block } => array
  # Returns an array containing the leading elements for which block is false or nil.
  def select_until
    a = []
    each{|x| yield(x) ? break : (a << x)}
    return a
  end


  # enum.select_with_index {|obj,i| block } => array
  # Calls block with two arguments, the item and its index, for each item in enum.
  # Returns an array containing the leading elements for which block is not false or nil.
  def select_with_index
    i = 0
    a = []
    each{|x| yield(x,i) ? a << x : break}
    return a
  end


  # enum.nitems_while {| obj | block } => number of items
  # Returns the number of leading elements for which block is not false or nil.
  def nitems_while
    n = 0
    each{|x| yield(x) ? (n+=1) : break}
    return n
  end


  # enum.nitems_until {| obj | block } => number of items
  # Returns the number of leading elements for which block is false.
  def nitems_until
    n = 0
    each{|x| yield(x) ? break : (n+=1)}
    return n
irb
  end


  # enum.nitems_with_index {|obj,i| block } => number of items
  # Calls block with two arguments, the item and its index, for each item in enum.
  # Returns the number of leading elements for which block is true.
  def nitems_with_index
    i = 0
    each{|x| yield(x,i) ? (i+=1) : break}
    return i
  end


  # Passes each element of the collection to the given block.
  # The block can returns number (which is added to the sum),
  # or true (which means continue) or false (which means return).

  def sum_while
    sum=0
    each{|x|
      n = yield x
      next if n==true
      return if n==false
      sum+=n
    }
    return sum
  end

end