import 'package:flutter/material.dart';
import 'package:world_currency_app/presentation/screens/currency_list_screen/currency_list_screen.dart';

class AddCurrencyButton extends StatelessWidget {
  const AddCurrencyButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const CurrencyList(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 15.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(255, 227, 240, 252),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.blue[800],
                    size: 30.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Add Currency',
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
