FactoryGirl.define do
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
    color 'black'
    captured nil
  end

  # factory :king do
  #   color 'black'
  # end

end
