import 'package:cure_link/models/medicine_model.dart';
import 'package:cure_link/screens/medicine_details_screen/medicine_details_screen.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomMedicineContainer extends StatefulWidget {
  const CustomMedicineContainer({
    super.key,
    this.medicineModel,
    this.isGridView = false,
  });
  final MedicineModel? medicineModel;
  final bool isGridView;

  @override
  State<CustomMedicineContainer> createState() =>
      _CustomMedicineContainerState();
}

class _CustomMedicineContainerState extends State<CustomMedicineContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MedicineDetailsScreen(
                medicineModel: widget.medicineModel!,
              );
            },
          ),
        );
      },
      child: Container(
        width: widget.isGridView ? null : 118,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.lightGreyColor2),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 2, right: 8, bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: widget.isGridView ? 8 : 18),

              Image.network(
                widget.medicineModel!.imagePathNote,
                width: double.infinity,
                height: 58,
                fit: BoxFit.cover,
              ),
              SizedBox(height: widget.isGridView ? 8 : 18),
              Text(
                widget.medicineModel!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.medicineModel!.quantityPcs,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: AppColor.darkGreyColor2),
              ),
              widget.isGridView ? const Spacer() : const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    widget.medicineModel!.priceNote,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MedicineDetailsScreen(
                              medicineModel: widget.medicineModel!,
                            );
                          },
                        ),
                      );
                    },
                    child: Icon(Icons.add_circle, color: AppColor.greenColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
