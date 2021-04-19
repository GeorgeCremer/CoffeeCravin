#### Installation:
- To use the app, you'll need to apply for a free Foursquare developer account and use your own credentials. see https://developer.foursquare.com/docs/places-api/getting-started/ 
- To input your own credentials navigate to: CoffeeCravin/Utilities/FourSquareCredentials.plist and input your Client ID & Client Secret.

#### Thought process:
Sketched out a simple design and thought about usable elements 
- MapView
- SearchButton 
- MapAnnotations
- MapCallOutViews Assessed the API response and modelled the data for use with JSON decoder.
- I chose MVP to more easily be able to test the networking manager through dependency injection (rather than using a singleton).

#### Some little extras:
- Used custom MapAnnotations + CallOuts.
- Enabled navigation from the callout
- Added a button to recenter the map on the user's location

#### Things to improve:
- Testing needs to be expanded; I focussed on the more complex testing of the network manager, which hopefully is enough for the scope of this demonstration project. 
- Need to change the distance calculation to be from the user's current location rather than the centre of the map.
