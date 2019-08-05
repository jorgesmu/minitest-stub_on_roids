require "minitest/stub_on_roids"
require "minitest/spec"

class Banana
  def initialize(weight, color); end
  def peel(speed); end
end

describe Minitest::StubOnRoids do
  Banana.extend Minitest::StubOnRoids

  let(:banana_mock) do
    mock = MiniTest::Mock.new
    mock.expect(:peel, "Peeling!", [10])
  end

  describe ".stub_with_args" do
    describe "when a stubbed method is called with all expected args" do
      it "works like a charm" do
        Banana.stub_with_args(:new, banana_mock, [3.0, "Yellow"]) do
          banana = Banana.new(3.0, "Yellow")
        end
      end
    end

    describe "when a stubbed method is called with unexpected args" do
      it "raises a StubbedMethodArgsError" do
        assert_raises StubbedMethodArgsError do
          Banana.stub_with_args(:new, banana_mock, [3.0, "Green"]) do
            banana = Banana.new(3.0, "Yellow")
          end
        end
      end
    end
  end

  describe ".stub_and_expect" do
    describe "when a stubbed method is called the same amount of times it is expected" do
      it "works like a charm" do
        Banana.stub_and_expect(:new, banana_mock, [3.0, "Yellow"], times: 3) do
          banana = Banana.new(3.0, "Yellow")
          banana = Banana.new(3.0, "Yellow")
          banana = Banana.new(3.0, "Yellow")
        end
      end
    end

    describe "a stubbed method is called more times than expected" do
      it "raises MockExpectationError" do
        assert_raises MockExpectationError do
          Banana.stub_and_expect(:new, banana_mock, [3.0, "Yellow"], times: 1) do
            banana = Banana.new(3.0, "Yellow")
            banana = Banana.new(3.0, "Yellow")
          end
        end
      end
    end

    describe "when a stubbed method is expectedly called without args" do
      it "works like a charm" do
        Banana.stub_and_expect(:new, banana_mock) do
          banana = Banana.new
        end
      end
    end

    describe "a method is called with an unexpected amount of args" do
      it "raises an ArgumentError" do
        assert_raises ArgumentError do
          Banana.stub_and_expect(:new, banana_mock, [3.0]) do
            banana = Banana.new
          end
        end
      end
    end
  end
end