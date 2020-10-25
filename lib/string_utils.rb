class String
  def snakify
    gsub(/\W/, '_').underscore
  end

  def generate_random_color
    indice_ratios = self[0..2].chars.map { |c| (c.downcase.bytes[0] - 96) / 26.0 }

    "rgb(#{(57 * indice_ratios[0] + 200).floor},
    #{(57 * indice_ratios[1] + 200).floor},
    #{(57 * indice_ratios[2] + 200).floor})"
  end
end
