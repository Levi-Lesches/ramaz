import "../hybrid.dart";

import "cloud.dart";
import "interface.dart";
import "local.dart";

/// Handles calendar data in the cloud and on the device. 
/// 
/// The calendar and schedules should always be downloaded at the same time, 
/// because changes to the calendar may reference newly created schedules. 
/// 
/// For accuracy, the current month's calendar should be updated every day. 
/// Make sure to call [update] once per day. 
// ignore: lines_longer_than_80_chars
class HybridCalendar extends HybridDatabase<CalendarInterface> implements CalendarInterface {
	/// Bundles the cloud and local calendar data.
	HybridCalendar() : super(
		cloud: CloudCalendar(),
		local: LocalCalendar(),
	);

	@override
	Future<void> signIn() async {
		await local.setSchedules(await cloud.getSchedules());
		for (int month = 1; month <= 12; month++) {
			await local.setMonth(month, await cloud.getMonth(month));
		}
	}

	@override
	Future<Map> getMonth(int month) => local.getMonth(month);	

	@override
	Future<void> setMonth(int month, Map json) async {
		await cloud.setMonth(month, json);
		await local.setMonth(month, json);
	}

	@override
	Future<List<Map>> getSchedules() => local.getSchedules();

	@override
	Future<void> setSchedules(List<Map> json) async {
		await cloud.setSchedules(json);
		await local.setSchedules(json);
	}

	/// Downloads the parts of the calendar necessary to be up-to-date.
	/// 
	/// Just the schedules and the current month.
	Future<void> update() async {
		final int currentMonth = DateTime.now().month;
		await local.setSchedules(await cloud.getSchedules());
		await local.setMonth(currentMonth, await cloud.getMonth(currentMonth));
	}
}