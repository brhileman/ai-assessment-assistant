if Rails.env.development?
  LetterOpener.configure do |config|
    # Automatically open emails in browser
    config.location = Rails.root.join('tmp', 'letter_opener')
  end
end 