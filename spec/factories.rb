# frozen_string_literal: true
FactoryGirl.define do
  factory :avatar do
  end
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'
  end

  factory :game do
    black_player_id 1
    white_player_id 2
    sequence :name do |n|
      "dummygame#{n}"
    end
  end

  factory :piece do
    type nil
    current_row_index nil
    current_column_index nil
    color nil
    captured nil
  end

  factory :queen, class: Queen do
    current_row_index 4
    current_column_index 4
    color nil
    game_id nil
  end

  factory :bishop, class: Bishop do
    current_row_index nil
    current_column_index nil
    color nil
    game_id nil
  end

  factory :king, class: King do
    current_row_index nil
    current_column_index nil
    color nil
    game_id nil
  end
end
