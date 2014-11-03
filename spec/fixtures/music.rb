class Artist

  attr_accessor :stage_name

  def initialize(name, attrs)
    @name = name
    @attrs = attrs
    @stage_name = attrs[:stage_name]
  end

  def starve
    Song.produce(10)
  end
end

class Singer < Artist

  SUPER_ATTRS = { singing: 10, dancing: 10, looks: 10 }
  HIPSTER_THRESHOLD = 10

  class << self
    def sellouts
      where(:album_sales > HIPSTER_THRESHOLD)
    end
  end

  def self.superstar
    first = %w[Michael Beyonce Cee-lo Devin]
    last = %w[Jackson Knowles Green Townsend]
    new("#{first.sample} #{last.sample}", SUPER_ATTRS.dup)
  end

  def status
    if self.album_sales > HIPSTER_THRESHOLD
      "sellout"
    else
      "cool"
    end
  end

  def songs
    Song.where(artist: self)
  end

  def sing
    mic = Performance::Equipment::Microphone
    mic.shout "♬ Hang the DJ! ♬"
  end
end

class Song

  def initialize(popularity)
    @popularity = popularity
  end
end

module Instruments

  class Stringed

    def initialize(num_strings)
      @num_strings = num_strings
    end
  end

  class Guitar < Stringed

    def initialize(sound)
      super(6)
      @sound = sound
    end
  end

end

module Performances
  module Equipment
    class Amp
    end

    class Microphone
    end
  end
end

