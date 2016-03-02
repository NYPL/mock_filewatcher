require "mock_filewatcher/version"
require 'faker'

class MockFilewatcher
  def create_fake_message
    fake_checksum = Digest::MD5.new
    fake_checksum.update rand(2000).to_s
    bag_path = "/bags/#{Faker::Lorem.words(2).join("/")}"
    filename = "#{Faker::Lorem.words(2).join}.mov"

    {:UUID => SecureRandom.uuid,
      :assetFileName => "#{filename}",
      :definition    => ["hd", "sd"].sample,
      :isInMMS       => [true, false].sample,
      :width         => (500..1000).to_a.sample,
      :height        => (500..1000).to_a.sample,
      :size          => (1024..200000).to_a.sample,
      :pathToBag     => bag_path,
      :pathToAsset   => "#{bag_path}/#{filename}",
      :checksum      => fake_checksum.to_s,
      :metadata      => {
        :title => Faker::Lorem.words(rand(6)+1).join,
        :identifier => "ABVVGTU".split("").shuffle.join,
        :typeOfResource => "moving image",
        :dateCreated => ["05/18/2015","07/20/1999","2/12/98E","06/07/77M",nil,""].sample,
        :division => ["dan_MIA", "dan", "myd", nil, ""].sample,
        :objectIdentifier => [Faker::Code.ean, Faker::Code.ean, nil].sample,
        :conditionNotes   => [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample,
        :contentNotes     => [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample,
        :otherNotes       => [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample,
        :accessNote       => [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample,
        :processingNotes  => [Faker::Lorem.sentences(rand(2)+1).join(" "), nil ].sample,
        :duration         => ["00:16:25:23", "01:1#{rand{8}+1}:25:23", "01:16:25:#{rand{9}}#{rand{9}}"].sample,
        :dateCaptured     => Faker::Date.backward(1000).strftime("%-m/%d/%y"),
        :projectIdentifier => "#{Faker::Lorem.words(1).first}.xls",
        :formerClassmark   => "* #{('A'..'Z').to_a.shuffle[0..4].join} #{('1'..'9').to_a.shuffle[0..2].join}"
        }
     }
  end
end
