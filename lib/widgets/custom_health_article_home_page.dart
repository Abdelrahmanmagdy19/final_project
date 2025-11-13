import 'package:cure_link/models/model/health_artilcle_model.dart';
import 'package:cure_link/screens/health_artical_details.dart';
import 'package:cure_link/utils/app_color.dart';
import 'package:flutter/material.dart';

class CustomHealthArticleHomePage extends StatelessWidget {
  const CustomHealthArticleHomePage({
    super.key,
    required this.healthArticleModel,
  });

  final HealthArticleModel healthArticleModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HealthArticleDetails(healthArticleModel: healthArticleModel),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.lightGreyColor2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(healthArticleModel.imageUrl),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  healthArticleModel.title,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'inter',
                    color: AppColor.darkGreyColor2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
