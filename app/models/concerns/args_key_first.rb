module ArgsKeyFirst
  extend ActiveSupport::Concern

  def args_key_first(args, *keys)
    array = args.to_h.sort_by do |k, _v|
      index = keys.index k.to_sym
      index ? (index - keys.size) : 1
    end
    HashWithIndifferentAccess[array]
  end
end
