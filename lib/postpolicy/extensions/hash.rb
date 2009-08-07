class Hash

  def stringify_keys!
    self.replace( inject({}) { |hsh, (k, v)| hsh[k.to_sym]=v; hsh } )
  end

end
