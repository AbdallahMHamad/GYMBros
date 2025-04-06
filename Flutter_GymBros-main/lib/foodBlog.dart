import 'package:flutter/material.dart';

class FoodBlog extends StatelessWidget {
  const FoodBlog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Blog'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // High-Protein Meals
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'High-Protein Meals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Include foods like eggs, chicken, lean meats, and dairy products.'),
              const SizedBox(height: 10),
              Image.network(
                "https://www.thrivenaija.com/wp-content/uploads/2020/01/healthy-food-high-in-protein.jpg",
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Complex Carbohydrates
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Carbohydrates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Consume complex carbs like whole grains, rice, potatoes, and oats.'),
              const SizedBox(height: 10),
              Image.network(
                'https://i.pinimg.com/originals/3f/ce/2d/3fce2d4866b01a971483d1355cf33ffc.jpg',
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Healthy Fats
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Healthy Fats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Add sources like nuts, seeds, avocados, and olive oil.'),
              const SizedBox(height: 10),
              Image.network(
                'https://i.ytimg.com/vi/Q_Pj8nIWGoE/maxresdefault.jpg',
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Lean Proteins
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Lean Proteins',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Focus on lean protein sources like chicken breast, fish, tofu, and legumes.'),
              const SizedBox(height: 20),
              Image.network(
                'https://www.trifectanutrition.com/hs-fs/hubfs/Lean-Protein.jpg?width=1830&name=Lean-Protein.jpg',
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Low-Carb Foods
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Low-Carb Foods',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Incorporate vegetables, salads, and whole grains in moderation.'),
              const SizedBox(height: 30),
              Image.network(
                'https://www.aboutlowcarbfoods.org/wp-content/uploads/2015/02/LowCarbFoodsList.jpg',
                fit: BoxFit.cover,
                height: 150,
                width: double.infinity,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Unsaturated Fats
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Healthy Fats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                  'Opt for unsaturated fats from sources like avocados, nuts, and seeds.'),
              const SizedBox(height: 120),
              Image.network(
                'https://www.pmfias.com/wp-content/uploads/2016/02/Type-of-Fats-Saturated-Unsaturated-Trans-Fat.png',
                fit: BoxFit.cover,
                height: 250,
                width: double.infinity,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
