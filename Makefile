dep:
	bundle install && bundle exec pod install && carthage bootstrap --platform ios
