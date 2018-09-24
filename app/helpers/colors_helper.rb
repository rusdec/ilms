module ColorsHelper
  def random_color
    pallete.shuffle[rand(pallete.length - 1)]
  end

  def pallete
    %w(#5aa1b5 #a15196 #9eb354 #b3615a #499969
       #bdcfff #995264 #995264 #7cb566 #a15eb3
       #7cad56 #e9aeff #b35272 #996149 #ffe3ae)
  end
end
