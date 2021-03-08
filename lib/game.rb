require_relative "card"
require_relative "deck"
require_relative "hand"
require_relative "player"
require "pry"

CARD_VALUES = [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]

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

    def return_card_value(card)
        CARD_VALUES.index(card)
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
        p "Your hand is: "
        print_hand(player)
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
        player.called = true
        self.current_bet = self.current_bet + raise_amount.to_i
        self.players.each do |other_player|
            if other_player != player
                if other_player.playing_round == true
                    other_player.called = false
                end
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
        player.called = true
    end

    def print_hand(player)
        player.hand.cards.each do |card|
            p card
        end
    end
    
    def replacement_question(player)
        print_hand(player)
        p "Hey, " + player.name + "!Enter the cards that you would like to replace starting from the highest index to the lowest or enter nothing to pass"
        response = gets.chomp
        if response
            player.hand.replace(response,self.deck)
        end
        player.called = true
        print_hand(player)
        p "__________________________"
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
            player.called = true
        end
    end

    def cycle_turn
        case self.turn
        when nil
            self.turn = self.players[0]
        when self.players[0]
            self.turn = self.players[1]
            if self.players[1].playing_round == false
                cycle_turn
            end
        when self.players[1]
            self.turn = self.players[2]
            if self.players[2].playing_round == false
                cycle_turn
            end
        when self.players[2]
            self.turn = self.players[3]
            if self.players[3].playing_round == false
                cycle_turn
            end
        when self.players[3]
            self.turn = self.players[0]
            if self.players[0].playing_round == false
                cycle_turn
            end
        end
    end

    def reset_bet_called_during_round
        self.current_bet = 0
        self.previous_bet = 0
        players.each do |player|
            player.last_bet = 0
            if player.playing_round == true
                player.called = false
            end
        end
        self.turn = nil
    end

    def reset_bet_called_after_round
        self.current_bet = 0
        self.previous_bet = 0
        players.each do |player|
                player.called = false
                player.last_bet = 0
        end
        self.turn = nil
    end

    def betting_round
        p "__________________________"
        p "Betting Round Begins"
        until players.all? { |player| player.called }
            cycle_turn
            begin
                action = turn_question(self.turn)
                turn_process(action, self.turn)
            rescue ArgumentError
                p "you messed up. Try again. Stop messing up."
                retry
            end
        end
        reset_bet_called_during_round
    end

    def drawing_round
        p "__________________________"
        p "Drawing Round Begins"
        until players.all? { |player| player.called }
            cycle_turn
            if self.turn.playing_round == true
                replacement_question(self.turn)
            end
        end
        reset_bet_called_during_round
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

    def showdown
        showdown_hash = Hash.new
        players_remaining = Array.new
        highest_values = Array.new
        highest_cards = Array.new
        players.each do |player|
            if player.playing_round = true
                player.hand.highest_value = player.hand.calculate_hand
                player.hand.calculate_highest_value_number
                p player.name
                player.hand.cards.each do |card|
                    p card
                end
                players_remaining << player
                highest_values << player.hand.highest_value
                highest_cards << player.hand.highest_card
                p player.hand.highest_value
                p player.hand.highest_card
                p "__________________________"
            end
        end
        p players_remaining
        p highest_values
        p highest_cards

        max_value = highest_values.max_by { |x| x }
        highest_values.each_with_index.max[1]

        players_highest_values = Array.new
        players_highest_values_high_cards = Array.new
        highest_values.each_with_index do |value, index|
            if value == max_value
                players_highest_values << players_remaining[index]
                players_highest_values_high_cards << return_card_value(highest_cards[index])
            end
        end

        max_high = players_highest_values_high_cards.max_by { |x| x }
        last_people_standing = Array.new
        if players_highest_values.length == 1
            players_highest_values[0].money += self.pot
        else
            players_highest_values_high_cards.each_with_index do |value, index|
                if value == max_high
                    last_people_standing << players_remaining[index]
                end
            end
            if last_people_standing.length == 1
                last_people_standing[0].name + "won " + self.pot.to_s
                last_people_standing[0].money += self.pot
            else
                pot_divided = (self.pot / last_people_standing.length)
                last_people_standing.each do |person|
                    p person.name + "won " + pot_divided_to.s
                    person.money += pot_divided
                end
            end
        end
        self.pot = 0
    end
    
    def print_standings
        players.each do |player|
            p player.name + "'s money = " + player.money.to_s
        end
    end

    def play
        until self.game_over == true
            players.map { |player| player.playing_round = true }
            print_standings
            betting_round
            drawing_round
            betting_round
            showdown
            reset_bet_called_after_round
        end
    end
end

test = Game.new("Ding","Dong","Witch","Dead")

test.play