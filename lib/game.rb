require_relative "card"
require_relative "deck"
require_relative "hand"
require_relative "player"
require "pry"

class Game
    attr_reader :deck
    attr_accessor :players, :pot, :player, :turn, :bet, :current_bet, :previous_bet

    def initialize(p1name, p2name, p3name, p4name)
        @deck = Deck.new
        @players = [Player.new(p1name), Player.new(p2name), Player.new(p3name), Player.new(p4name)]
        self.players.each do |player|
            player.hand = Hand.new(self.deck)
        end
        @current_bet = 0
        @previous_bet = 0
        @pot = 0
        @turn = nil
    end

    def bet(player,amount)
        player.remove_money(amount)
        self.pot = self.pot + amount
        player.last_bet = amount
        player.called = true
    end

    def discard_question
        p "Which cards would you like to discard?"
        cards = gets.chomp()
    end

    def turn_question(player)
        p "__________________________"
        p "Money: " + player.money.to_s
        p "It's your turn, " + player.name + "! Would you like to to fold, call, or raise?"
        p "Current bet is: " + self.current_bet.to_s
        p "Current pot is: " + self.pot.to_s
        action = gets.chomp()
    end

    def raise(player)
        begin
            p "Current bet is: " + self.current_bet.to_s
            p "Enter the amount you would like to raise by: "
            raise_amount = gets.chomp
=begin
            if raise_amount.to_i > player.money || raise_amount.to_i < self.current_bet
                raise ArgumentError
            end
=end
        rescue ArgumentError
            p "please enter a value that is greater than the current bet of : " + self.current_bet.to_s + " OR an amount you actually have, you clown!"
            retry
        end
        if player.last_bet > 0
            bet = raise_amount.to_i + self.current_bet - player.last_bet
        else    
            bet = raise_amount.to_i + self.current_bet
        end
        bet(player, bet)
        self.current_bet = self.current_bet + raise_amount.to_i
        self.players.each do |other_player|
            if other_player != player
                other_player.called = false
            end
        end
    end

    def call(player)
=begin
        if self.current_bet > player.money
            raise ArgumentError
        end
=end
        call_amount = self.current_bet - player.last_bet
        bet(player, call_amount)
        player.playing_round = true
    end

    def turn_process(action,player)
        if action == "raise"
            raise(player)
            players.each do |player|
                if player.called != true && player.playing_round == true
                    self.turn = player
                    action = turn_question(player)
                    turn_process(action, player)
                end
            end
        elsif action == "call"
            call(player)
        elsif action == "fold"
            player.playing_round = false
        end
    end

    def cycle_turn
        case self.turn
        when nil
            self.turn = self.players[0]
        when self.players[0]
            self.turn = self.players[1]
        when self.players[1]
            self.turn = self.players[2]
        when self.players[2]
            self.turn = self.players[3]
        else
            self.turn = nil
        end
    end

    def reset_bet
        self.current_bet = 0
        players.each do |player|
            player.called = false
        end
    end

    def play
        until self.game_over == true
            cycle_turn
            begin
                action = turn_question(self.turn)
                turn_process(action, self.turn)
            rescue ArgumentError
                p "you messed up. Try again. Stop messing up."
                retry
            end
        end

    end

    def game_over
        broke_players = 0
        self.players.each do |player|
            if player.money <= 0
                broke_players += 1
            end
        end
        if broke_players >= 3
            return true
        end
        false
    end
end

test = Game.new("Ding","Dong","Witch","Dead")

test.play