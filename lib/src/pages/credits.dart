import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

import "package:ramaz/data.dart";
import "package:ramaz/widgets.dart";

import "drawer.dart";

/// The Credits Page with a [ResponsiveContributorCard] for each contributor.
class CreditsPage extends StatelessWidget {
	/// Builds the Credits page.
	const CreditsPage();

	@override 
	Widget build (BuildContext context) => ResponsiveScaffold(
		drawer: const NavigationDrawer(),
		appBar: AppBar(title: const Text ("Credits")),
		bodyBuilder: (_) => ListView(
			children: [
				for (final Contributor contributor in Contributor.contributors)
					ResponsiveContributorCard(contributor)
			]
		)
	);
}

/// A class that shows info about each contributor.
/// 
/// This widget shows a [CompactContributorCard] for small screens
/// and [WideContributorCard] on larger screens.
class ResponsiveContributorCard extends StatelessWidget{
	/// The contributor this widget represents.
	final Contributor contributor;
	
	/// Creates a widget to represent a [Contributor].
	const ResponsiveContributorCard(this.contributor);

	@override 
	Widget build(BuildContext context) => Card(
		// vertical is 4 so that cards are separated by 8 
		margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
		elevation: 4,
		child: ResponsiveBuilder(
			builder: (_, LayoutInfo layout, __) => layout.isMobile
				? CompactContributorCard(contributor)
				: WideContributorCard(contributor),
		)
	);
}

/// A wide variant of the contributor card. 
class WideContributorCard extends StatelessWidget {
	/// The height of the card.
	/// 
	/// This widget is made of rows and columns instead of a ListTile. As such, we 
	/// have to manually specify the height, or else it will be unbounded. 
	static const double height = 150;

	/// The contributor shown by this card.
	final Contributor contributor;

	/// Creates a wide contributor card. 
	const WideContributorCard(this.contributor);

	@override
	Widget build(BuildContext context) => Container(
		height: height,
		padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
		child: Row(
			children: [
				Flexible(
					flex: 1,
					child: AspectRatio(
						aspectRatio: 1, 
						child: Image.network(contributor.imageName),
					),
				),
				const SizedBox(width: 8),
				Expanded(
					flex: 3,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
					 		Text(
								"${contributor.name} ${contributor.gradYear}",
								style: Theme.of(context).textTheme.headline5,
							),
							const SizedBox(height: 4),
							Text(
								contributor.title,
								style: Theme.of(context).textTheme.bodyText2,
								textScaleFactor: 1.1,
							),
							const SizedBox(height: 4),
							InkWell(
								onTap: () => launch("mailto:${contributor.email}"),
								child: Text(
									contributor.email,
									textScaleFactor: 1.1,
									style: Theme.of(context).textTheme.caption!.copyWith(
										color: Colors.blue.withAlpha(200), 
									),
								),
							),
						]
					),
				),
				const Spacer(),
				Expanded(
					flex: 3,
					child: Text(
						contributor.description,
						style: Theme.of(context).textTheme.subtitle1
					)
				),
				const Spacer(),
			]
		)
	);
}

/// A compact variant of the contributor card. 
class CompactContributorCard extends StatelessWidget {
	/// The contributor being represented.
	final Contributor contributor;

	/// Creates a compact contributor card.
	const CompactContributorCard(this.contributor);

	@override
	Widget build(BuildContext context) => Column(
		children: [
			ListTile(
				visualDensity: const VisualDensity(vertical: 3),
				title: Text("${contributor.name} ${contributor.gradYear}"),
				leading: CircleAvatar(
					radius: 48,  // a standard Material radius
					foregroundImage: NetworkImage(contributor.imageName),
				),
				subtitle: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(contributor.title),
						InkWell(
							onTap: () => launch("mailto:${contributor.email}"),
							child: Text(
								contributor.email,
								style: TextStyle(color: Colors.blue.withAlpha(200)),
							),
						),
					]
				),
			),
			Padding(
				padding: const EdgeInsets.all(16),
				child: Text(contributor.description),
			),
		]
	);
}
