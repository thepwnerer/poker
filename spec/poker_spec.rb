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