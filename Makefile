bootstrap:
	bundle install && bundle exec pod install && carthage bootstrap --platform ios

dep:
	carthage update --platform ios
