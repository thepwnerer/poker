require "card"
require "deck"
require "game"
require "hand"
require "player"

describe Player do
    #let(:player) { double("player") }
    subject(:player) { Player.new("Dave") }

    describe "#initialize" do
        it "creates the player with a name" do
            expect(player.name).to eq("Dave")
        end
        it "gives the player a hand when initializing" do
            expect(player.hand.length).to eq(0)
        end
    end

end

describe Card do
    subject(:card) { Card.new(9,"spades") }
    subject(:deck) { Deck.new }
    subject(:hand) { Hand.new(deck) }
    
    describe "#initialize" do
        it "creates the card with a value and suit" do
            expect(card.value).to eq(9)
            expect(card.suit).to eq("spades")
        end
    end
end

describe Deck do
    subject(:deck) { Deck.new }
    
    describe '#initialize' do
        it "creates the deck with 52 cards" do
            expect(deck.cards.length).to eq(52)
        end
    end

end

describe Hand do
    #let(:deck) { double("deck") }
    subject(:deck) { Deck.new }
    subject(:hand) { Hand.new(deck) }
    subject(:game) { Game.new("Dave", "Gavin", "Fernie", "Dinkle") }
    

    describe '#initialize' do
        it "takes five cards from the deck" do
            expect(hand.cards.length).to eq(5)
            expect(deck.cards.length).to eq(47)
        end
    end

    describe '#calculate_hand' do
        it "can take a hand with only a pair and return pair" do
            hand.cards = []
            hand.cards = [Card.new(9,"diamonds"),Card.new(9,"clubs"),Card.new(10,"clubs"),Card.new('J',"diamonds"),Card.new('Q',"diamonds")]
            expect(hand.calculate_hand).to eq("pair")
        end

        it "can take a hand with two a pairs and return two pairs" do
            hand.cards = []
            hand.cards = [Card.new(9,"diamonds"),Card.new(9,"clubs"),Card.new(10,"clubs"),Card.new(10,"diamonds"),Card.new('Q',"diamonds")]
            expect(hand.calculate_hand).to eq("two_pairs")
            expect(hand.highest_card).to eq(10)
        end

        it "can take a hand with three and return triples" do
            hand.cards = []
            hand.cards = [Card.new(9,"diamonds"),Card.new(9,"clubs"),Card.new(9,"hearts"),Card.new(10,"diamonds"),Card.new('Q',"diamonds")]
            expect(hand.calculate_hand).to eq("triple")
            expect(hand.highest_card).to eq(9)
        end

        it "can take a hand with five consecutive cards and give back straight" do
            hand.cards = []
            hand.cards = [Card.new(10,"hearts"),Card.new(9,"diamonds"),Card.new(8,"diamonds"),Card.new(7,"diamonds"),Card.new(6,"diamonds")]
            expect(hand.calculate_hand).to eq("straight")
            expect(hand.highest_card).to eq(10)
        end

        it "can take a hand with five of the same suit and return flush" do
            hand.cards = []
            hand.cards = [Card.new(10,"diamonds"),Card.new(8,"diamonds"),Card.new(7,"diamonds"),Card.new(6,"diamonds"),Card.new(5,"diamonds")]
            expect(hand.calculate_hand).to eq("flush")
            expect(hand.highest_card).to eq(10)
        end

        it "can take a hand with a pair and triples and return full house" do
            hand.cards = []
            hand.cards = [Card.new(9,"hearts"),Card.new(8,"diamonds"),Card.new(8,"hearts"),Card.new(9,"diamonds"),Card.new(9,"clubs")]
            expect(hand.calculate_hand).to eq("full_house")
            expect(hand.highest_card).to eq(9)
        end

        it "can take a hand with four of a kind and return quad" do
            hand.cards = []
            hand.cards = [Card.new(8,"hearts"),Card.new(8,"diamonds"),Card.new(8,"clubs"),Card.new(8,"spades"),Card.new(9,"clubs")]
            expect(hand.calculate_hand).to eq("quad")
            expect(hand.highest_card).to eq(8)
        end

        it "can take a hand with a straight and a flush and return straight_flush" do
            hand.cards = []
            hand.cards = [Card.new(8,"hearts"),Card.new(9,"hearts"),Card.new(10,"hearts"),Card.new("J","hearts"),Card.new("Q","hearts")]
            expect(hand.calculate_hand).to eq("straight_flush")
            expect(hand.highest_card).to eq("Q")
        end

        it "return value from hand" do
            hand.cards = []
            hand.cards = [Card.new(9,"diamonds"),Card.new(9,"clubs"),Card.new(10,"clubs"),Card.new('J',"diamonds"),Card.new('Q',"diamonds")]
            expect(hand.calculate_value).to eq(1)
        end

        it "return highest value from hand" do
            hand.cards = []
            hand.cards = [Card.new(7,"diamonds"),Card.new(9,"clubs"),Card.new(10,"clubs"),Card.new('J',"diamonds"),Card.new('Q',"diamonds")]
            expect(hand.calculate_highest).to eq("Q")
        end
    end
end

describe Game do
    subject(:game) { Game.new("Dave", "Gavin", "Fernie", "Dinkle") }

    describe '#initialize' do
        it "creates a deck, four players, and gives them each a hand" do
            expect(game.deck.cards.length).to eq(32)
            expect(game.players.length).to eq(4)
            expect(game.players[0].hand.cards.length).to eq(5)
        end
    end

    describe "#bet" do
        it "removes money from the player and puts it in the pot" do
            game.bet(game.players[0],500)
            expect(game.pot).to eq(500)
            expect(game.players[0].money).to eq(500)
        end
    end

end