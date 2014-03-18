class BinaryHeap

  attr_accessor :nodes, :less_than

  def root
    exchange(1, self.nodes.length)
    orig_root = self.nodes.delete_at(self.nodes.length-1)
    sink
    orig_root
  end
  
  def initialize(inverse=false, *nodes)
    if inverse
      self.instance_eval do 
        def min
          root
        end
      end
      self.less_than = :<

    else
      self.instance_eval do
        def max
          root
        end
      end
      self.less_than = :>
    end
    
    self.nodes = []
    
    nodes.each do |n|
      self.push(n)
    end
  end

  def empty?
    self.nodes.empty?    
  end

  def push(node)
    self.nodes << node
    swim
  end

  private

    def sink
      index = 1
      while index <= (self.nodes.length/2)
        if self.nodes[index*2]
          inplace_left = self.nodes[index-1].send(self.less_than, self.nodes[index*2])
        else
          inplace_left = true
        end
        if self.nodes[index*2+1]
          inplace_right = self.nodes[index-1].send(self.less_than, self.nodes[index*2+1])
        else
          inplace_right = true
        end
        if inplace_left && inplace_right
          break
        elsif inplace_right
          exchange(index*2+1, index)
          index = (index*2+1)
        else
          exchange(index*2, index)
          index = index*2
        end
      end
    end

    def swim
      index = self.nodes.length
      while index > 1 do
        if self.nodes[index-1].send(self.less_than, self.nodes[index/2-1])
          exchange(index, (index/2))
          index = (index/2)
        else
          break
        end
      end  
    end

    def exchange(index1, index2)
      temp = self.nodes[index1-1] 
      self.nodes[index1-1] = self.nodes[index2-1]
      self.nodes[index2-1] = temp
    end

end
