require "spec_helper"
require "in_memory_repository"

describe InMemoryRepository do
  subject(:repo) { InMemoryRepository.new }

  describe "#store" do
    it "accepts path and IP" do
      repo.store("/", "1.1.1.1")
    end
  end

  describe "#each_by_hits" do
    context "for a single path" do
      before do
        repo.store("/home", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
      end

      it "returns a nested array of paths and their hits" do
        expect(repo.each_by('hits')).to eq(
          [
            { path: "/home", hits: 3, uniques: 1 }
          ]
        )
      end
    end

    context "for multiple paths" do
      # The IP isn't important here; it can be ignored for hits
      before do
        repo.store("/magicians", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
        repo.store("/welcome", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
        repo.store("/welcome", "1.1.1.1")
      end

      it "returns a sorted, nested array of paths and hits" do
        expect(repo.each_by('hits')).to eq(
          [
            { path: "/home", hits: 3, uniques: 1 },
            { path: "/welcome", hits: 2, uniques: 1 },
            { path: "/magicians", hits: 1, uniques: 1 },
          ]
        )
      end
    end
  end

  describe "#each_by_uniques" do
    context "for multiple paths" do
      before do
        repo.store("/magicians", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
        repo.store("/welcome", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
        repo.store("/home", "1.1.1.1")
        repo.store("/welcome", "2.2.2.2")
      end

      it "returns a sorted, nested array of paths and hits" do
        expect(repo.each_by('uniques')).to eq(
          [
            { path: "/welcome", hits: 2, uniques: 2 },
            { path: "/magicians", hits: 1, uniques: 1 },
            { path: "/home", hits: 3, uniques: 1 },
          ]
        )
      end
    end
  end
end