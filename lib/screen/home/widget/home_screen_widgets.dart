import 'package:flutter/material.dart';

Widget offlineOnlineStatusCard(
    {bool isOffline = false, String? amount, String? mothYear}) {
  return Expanded(
    child: Card(
      color: isOffline == false
          ? const Color(0xffE3FDE9)
          : const Color(0xffFDE3E3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              isOffline == false
                  ? 'ONLINE DAYS\n[${mothYear ?? "DEC 2024"}]'
                  : 'OFFLINE DAYS\n[${mothYear ?? "DEC 2024"}]',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isOffline == false
                      ? const Color(0xff0C8910)
                      : const Color(0xffF54242)),
            ),
            const SizedBox(height: 8),
            Text(
              amount ?? '12345.00',
              style: TextStyle(
                color: isOffline == false
                    ? const Color(0xff0D690A)
                    : const Color(0xffC01515),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
