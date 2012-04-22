require "erb"
class Test
  HELLO = %w[ helo hello hell]

  def self.hello
    HELLO.each { |h| puts h }
  end

  SAY_HELLO = lambda { hello }

  def test
    SAY_HELLO.call
  end
end


test = Test.new
test.test