# frozen_string_literal: true

RSpec.describe '1KO Tournament Graph Specification' do
  describe 'rounds' do
    context 'in 4 competitors tree' do
      let(:tournament) { Ko::SingleElimination::TournamentFactory.tournament(size: 2) }

      it 'are generated as expected' do
        expected_rounds = %w[w1 w2]
        round_keys = tournament.rounds.map { |_, round| round.key }

        expect(round_keys.sort).to eq(expected_rounds.sort)
      end

      it 'have got expected matches' do
        expected_matches = {
          'w1' => %w[2.w1.1 2.w1.2],
          'w2' => %w[2.w2.1]
        }

        expected_matches.each do |round_name, expected|
          stringified_round_matches =
            tournament.rounds[round_name].matches.map { |_, m| m.to_s }

          expect(stringified_round_matches).to eq(expected)
        end
      end
    end

    context 'in 8 competitors tree' do
      let(:tournament) { Ko::SingleElimination::TournamentFactory.tournament(size: 4) }

      it 'are generated as expected' do
        expected_rounds = %w[w1 w2 w3]
        round_keys = tournament.rounds.map { |_, round| round.key }

        expect(round_keys.sort).to eq(expected_rounds.sort)
      end

      it 'have got expected matches' do
        expected_matches = {
          'w1' => %w[4.w1.1 4.w1.2 4.w1.3 4.w1.4],
          'w2' => %w[4.w2.1 4.w2.2],
          'w3' => %w[4.w3.1]
        }

        expected_matches.each do |round_name, expected|
          stringified_round_matches =
            tournament.rounds[round_name].matches.map { |_, m| m.to_s }

          expect(stringified_round_matches).to eq(expected)
        end
      end
    end

    context 'in 16 competitors tree' do
      let(:tournament) { Ko::SingleElimination::TournamentFactory.tournament(size: 8) }

      it 'are generated as expected' do
        expected_rounds = %w[w1 w2 w3 w4]
        round_keys = tournament.rounds.map { |_, round| round.key }

        expect(round_keys.sort).to eq(expected_rounds.sort)
      end

      it 'have got expected matches' do
        expected_matches = {
          'w1' => %w[8.w1.1 8.w1.2 8.w1.3 8.w1.4 8.w1.5 8.w1.6 8.w1.7 8.w1.8],
          'w2' => %w[8.w2.1 8.w2.2 8.w2.3 8.w2.4],
          'w3' => %w[8.w3.1 8.w3.2],
          'w4' => %w[8.w4.1]
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
      let(:tournament) { Ko::SingleElimination::TournamentFactory.tournament(size: 2) }

      it 'have proper paths' do
        expected_paths = {
          '2.w1.1' => { next: '2.w2.1' },
          '2.w1.2' => { next: '2.w2.1' },
          '2.w2.1' => { next: nil }
        }

        paths = tournament.rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            [
              match.to_s,
              {
                next: match.next&.to_s
              }
            ]
          end
        end.to_h

        expect(paths).to eq(expected_paths)
      end
    end

    context 'in 8 competitors tree' do
      let(:tournament) { Ko::SingleElimination::TournamentFactory.tournament(size: 4) }

      it 'have proper paths' do
        expected_paths = {
          '4.w1.1' => { next: '4.w2.1' },
          '4.w1.2' => { next: '4.w2.1' },
          '4.w1.3' => { next: '4.w2.2' },
          '4.w1.4' => { next: '4.w2.2' },
          '4.w2.1' => { next: '4.w3.1' },
          '4.w2.2' => { next: '4.w3.1' },
          '4.w3.1' => { next: nil }
        }

        paths = tournament.rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            [
              match.to_s,
              {
                next: match.next&.to_s
              }
            ]
          end
        end.to_h

        expect(paths).to eq(expected_paths)
      end
    end

    context 'in 16 competitors tree' do
      let(:tournament) { Ko::SingleElimination::TournamentFactory.tournament(size: 8) }

      it 'have proper paths' do
        expected_paths = {
          '8.w1.1' => { next: '8.w2.1' },
          '8.w1.2' => { next: '8.w2.1' },
          '8.w1.3' => { next: '8.w2.2' },
          '8.w1.4' => { next: '8.w2.2' },
          '8.w1.5' => { next: '8.w2.3' },
          '8.w1.6' => { next: '8.w2.3' },
          '8.w1.7' => { next: '8.w2.4' },
          '8.w1.8' => { next: '8.w2.4' },
          '8.w2.1' => { next: '8.w3.1' },
          '8.w2.2' => { next: '8.w3.1' },
          '8.w2.3' => { next: '8.w3.2' },
          '8.w2.4' => { next: '8.w3.2' },
          '8.w3.1' => { next: '8.w4.1' },
          '8.w3.2' => { next: '8.w4.1' },
          '8.w4.1' => { next: nil }
        }

        paths = tournament.rounds.values.flat_map do |round|
          round.matches.values.map do |match|
            [
              match.to_s,
              {
                next: match.next&.to_s
              }
            ]
          end
        end.to_h

        expect(paths).to eq(expected_paths)
      end
    end
  end
end
