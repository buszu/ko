# frozen_string_literal: true

RSpec.describe 'Tournament Graph Specification' do
  describe 'rounds' do
    context 'in 4 competitors tree' do
      let(:tournament) { Ko::TournamentFactory.tournament(size: 2) }

      it 'are generated as expected' do
        expected_rounds = %w[lw0 l2 l1 w1 w2 w3 fw0]
        round_names = tournament.rounds.map { |_, round| round.name }

        expect(round_names.sort).to eq(expected_rounds.sort)
      end

      it 'have got expected matches' do
        expected_matches = {
          'lw0' => [],
          'l2' => %w[2.l2.1],
          'l1' => %w[2.l1.1],
          'w1' => %w[2.w1.1 2.w1.2],
          'w2' => %w[2.w2.1],
          'w3' => %w[2.w3.1],
          'fw0' => []
        }

        expected_matches.each do |round_name, expected|
          stringified_round_matches =
            tournament.rounds[round_name].matches.map { |_, m| m.to_s }

          expect(stringified_round_matches).to eq(expected)
        end
      end
    end

    context 'in 8 competitors tree' do
      let(:tournament) { Ko::TournamentFactory.tournament(size: 4) }

      it 'are generated as expected' do
        expected_rounds = %w[lw0 l4 l3 l2 l1 w1 w2 w3 w4 fw0]
        round_names = tournament.rounds.map { |_, round| round.name }

        expect(round_names.sort).to eq(expected_rounds.sort)
      end

      it 'have got expected matches' do
        expected_matches = {
          'lw0' => [],
          'l4' => %w[4.l4.1],
          'l3' => %w[4.l3.1],
          'l2' => %w[4.l2.1 4.l2.2],
          'l1' => %w[4.l1.1 4.l1.2],
          'w1' => %w[4.w1.1 4.w1.2 4.w1.3 4.w1.4],
          'w2' => %w[4.w2.1 4.w2.2],
          'w3' => %w[4.w3.1],
          'w4' => %w[4.w4.1],
          'fw0' => []
        }

        expected_matches.each do |round_name, expected|
          stringified_round_matches =
            tournament.rounds[round_name].matches.map { |_, m| m.to_s }

          expect(stringified_round_matches).to eq(expected)
        end
      end
    end

    context 'in 16 competitors tree' do
      let(:tournament) { Ko::TournamentFactory.tournament(size: 8) }

      it 'are generated as expected' do
        expected_rounds = %w[lw0 l6 l5 l4 l3 l2 l1 w1 w2 w3 w4 w5 fw0]
        round_names = tournament.rounds.map { |_, round| round.name }

        expect(round_names.sort).to eq(expected_rounds.sort)
      end

      it 'have got expected matches' do
        expected_matches = {
          'lw0' => [],
          'l6' => %w[8.l6.1],
          'l5' => %w[8.l5.1],
          'l4' => %w[8.l4.1 8.l4.2],
          'l3' => %w[8.l3.1 8.l3.2],
          'l2' => %w[8.l2.1 8.l2.2 8.l2.3 8.l2.4],
          'l1' => %w[8.l1.1 8.l1.2 8.l1.3 8.l1.4],
          'w1' => %w[8.w1.1 8.w1.2 8.w1.3 8.w1.4 8.w1.5 8.w1.6 8.w1.7 8.w1.8],
          'w2' => %w[8.w2.1 8.w2.2 8.w2.3 8.w2.4],
          'w3' => %w[8.w3.1 8.w3.2],
          'w4' => %w[8.w4.1],
          'w5' => %w[8.w5.1],
          'fw0' => []
        }

        expected_matches.each do |round_name, expected|
          stringified_round_matches =
            tournament.rounds[round_name].matches.map { |_, m| m.to_s }

          expect(stringified_round_matches).to eq(expected)
        end
      end
    end
  end

  describe 'matches' do
    context 'in 4 competitors tree' do
      let(:tournament) { Ko::TournamentFactory.tournament(size: 2) }

      it 'have proper paths' do
        expected_paths = {
          '2.l2.1' => { next_won: '2.w3.1', next_lost: '' },
          '2.l1.1' => { next_won: '2.l2.1', next_lost: '' },
          '2.w1.1' => { next_won: '2.w2.1', next_lost: '2.l1.1' },
          '2.w1.2' => { next_won: '2.w2.1', next_lost: '2.l1.1' },
          '2.w2.1' => { next_won: '2.w3.1', next_lost: '2.l2.1' },
          '2.w3.1' => { next_won: '', next_lost: '' }
        }

        paths = tournament.rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            x = match
            [
              match.to_s,
              {
                next_won: match.next.to_s,
                next_lost: match.next(won: false).to_s
              }
            ]
          end
        end.to_h

        expect(paths).to eq(expected_paths)
      end
    end

    context 'in 8 competitors tree' do
      let(:tournament) { Ko::TournamentFactory.tournament(size: 4) }

      it 'have proper paths' do
        expected_paths = {
          '4.l4.1' => { next_won: '4.w4.1', next_lost: '' },
          '4.l3.1' => { next_won: '4.l4.1', next_lost: '' },
          '4.l2.1' => { next_won: '4.l3.1', next_lost: '' },
          '4.l2.2' => { next_won: '4.l3.1', next_lost: '' },
          '4.l1.1' => { next_won: '4.l2.1', next_lost: '' },
          '4.l1.2' => { next_won: '4.l2.2', next_lost: '' },
          '4.w1.1' => { next_won: '4.w2.1', next_lost: '4.l1.1' },
          '4.w1.2' => { next_won: '4.w2.1', next_lost: '4.l1.1' },
          '4.w1.3' => { next_won: '4.w2.2', next_lost: '4.l1.2' },
          '4.w1.4' => { next_won: '4.w2.2', next_lost: '4.l1.2' },
          '4.w2.1' => { next_won: '4.w3.1', next_lost: '4.l2.2' },
          '4.w2.2' => { next_won: '4.w3.1', next_lost: '4.l2.1' },
          '4.w3.1' => { next_won: '4.w4.1', next_lost: '4.l4.1' },
          '4.w4.1' => { next_won: '', next_lost: '' }
        }

        paths = tournament.rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            x = match
            [
              match.to_s,
              {
                next_won: match.next.to_s,
                next_lost: match.next(won: false).to_s
              }
            ]
          end
        end.to_h

        expect(paths).to eq(expected_paths)
      end
    end

    context 'in 16 competitors tree' do
      let(:tournament) { Ko::TournamentFactory.tournament(size: 8) }

      it 'have proper paths' do
        expected_paths = {
          '8.l6.1' => { next_won: '8.w5.1', next_lost: '' },
          '8.l5.1' => { next_won: '8.l6.1', next_lost: '' },
          '8.l4.1' => { next_won: '8.l5.1', next_lost: '' },
          '8.l4.2' => { next_won: '8.l5.1', next_lost: '' },
          '8.l3.1' => { next_won: '8.l4.1', next_lost: '' },
          '8.l3.2' => { next_won: '8.l4.2', next_lost: '' },
          '8.l2.1' => { next_won: '8.l3.1', next_lost: '' },
          '8.l2.2' => { next_won: '8.l3.1', next_lost: '' },
          '8.l2.3' => { next_won: '8.l3.2', next_lost: '' },
          '8.l2.4' => { next_won: '8.l3.2', next_lost: '' },
          '8.l1.1' => { next_won: '8.l2.1', next_lost: '' },
          '8.l1.2' => { next_won: '8.l2.2', next_lost: '' },
          '8.l1.3' => { next_won: '8.l2.3', next_lost: '' },
          '8.l1.4' => { next_won: '8.l2.4', next_lost: '' },
          '8.w1.1' => { next_won: '8.w2.1', next_lost: '8.l1.1' },
          '8.w1.2' => { next_won: '8.w2.1', next_lost: '8.l1.1' },
          '8.w1.3' => { next_won: '8.w2.2', next_lost: '8.l1.2' },
          '8.w1.4' => { next_won: '8.w2.2', next_lost: '8.l1.2' },
          '8.w1.5' => { next_won: '8.w2.3', next_lost: '8.l1.3' },
          '8.w1.6' => { next_won: '8.w2.3', next_lost: '8.l1.3' },
          '8.w1.7' => { next_won: '8.w2.4', next_lost: '8.l1.4' },
          '8.w1.8' => { next_won: '8.w2.4', next_lost: '8.l1.4' },
          '8.w2.1' => { next_won: '8.w3.1', next_lost: '8.l2.4' },
          '8.w2.2' => { next_won: '8.w3.1', next_lost: '8.l2.3' },
          '8.w2.3' => { next_won: '8.w3.2', next_lost: '8.l2.2' },
          '8.w2.4' => { next_won: '8.w3.2', next_lost: '8.l2.1' },
          '8.w3.1' => { next_won: '8.w4.1', next_lost: '8.l4.2' },
          '8.w3.2' => { next_won: '8.w4.1', next_lost: '8.l4.1' },
          '8.w4.1' => { next_won: '8.w5.1', next_lost: '8.l6.1' },
          '8.w5.1' => { next_won: '', next_lost: '' }
        }

        paths = tournament.rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            x = match
            [
              match.to_s,
              {
                next_won: match.next.to_s,
                next_lost: match.next(won: false).to_s
              }
            ]
          end
        end.to_h

        expect(paths).to eq(expected_paths)
      end
    end
  end
end
