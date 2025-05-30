// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../widgets.dart';

GestureDetector appointmentCard(BuildContext ctx,
    {required Appointment appointment}) {
  return GestureDetector(
    onTap: () {
      editAppointment(ctx, appointment);
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          defaultShadow,
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/medical.png',
            width: 60,
            height: 60,
          ),
          spacerWidth(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctor,
                  style: subtitleTextStyle,
                ),
                if (appointment.note != null) ...[
                  Text(
                    appointment.note!,
                    style: captionTextStyle.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  )
                ],
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: VerticalDivider(
              width: 20,
              thickness: 2,
              indent: 0,
              endIndent: 0,
              color: darkGrayColor,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(appointment.time),
                style: subtitleTextStyle,
              ),
              Text(
                DateFormat('h:mm a').format(appointment.time),
                style: captionTextStyle,
              )
            ],
          )
        ],
      ),
    ),
  );
}
