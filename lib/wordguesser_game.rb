require 'byebug'
class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  
  # Get a word from remote "random word" service
  
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses= ""
  end
  
  

  def guess(user_guess)
    
    raise ArgumentError, "Input is nil." if user_guess == nil
    user_guess.downcase!
    raise ArgumentError, "Invalid guess." if !(user_guess =~/[a-z]/)
    if @word.include?(user_guess) && !(@guesses.include?(user_guess))
      # Will set guess to new format
      @guesses += user_guess
      return true

    elsif !(@word.include?(user_guess)) && !(@wrong_guesses.include?(user_guess))
      @wrong_guesses += user_guess
      return true
    end
    return false
  end 

  def word_with_guesses()
    # Set the guess with underscores 
    guess_word = "-" * @word.length
    @guesses.each_char do |char_g|     
      if @word.include?(char_g)       
        @word.each_char.with_index do |char_w, index|
          if char_w == char_g        
            guess_word[index] = char_g
          end 
        end
      end 
    end 
    return guess_word   
  end 

  def check_win_or_lose()
    
    if word_with_guesses() == @word && @wrong_guesses.length < 7 
      return :win
    elsif word_with_guesses() != @word && @wrong_guesses.length.eql?(7)
      return :lose 
    else 
      return :play
    end 
  end 
  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
