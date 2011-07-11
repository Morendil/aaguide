# encoding: UTF-8

String.class_eval do
  def indent
    return "            "+self
  end
end

def desc
  'Definition'
end

def syno
  'Also known as'
end

def abus
  'Common pitfalls'
end

def histo
  'Origins'
end

def progression
  'Skill levels'
end

def signes
  'Signs of use'
end

def benefices
  'Expected benefits'
end

def cost
  'Potential costs'
end

def resources
  'Further reading'
end

def pubs
  'Academic publications'
end

def training
  'Training'
end

def experts
  'Experts'
end
