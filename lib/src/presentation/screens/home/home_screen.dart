// lib/src/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/portfolio_summary_card.dart';
import '../../widgets/stock_card.dart';
import '../portfolio/add_stock_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onAddPressed() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddStockScreen()));
  }

  void _onSettingsPressed() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppStrings.myInvestments,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _onSettingsPressed,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: _onAddPressed,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTabChanged: _onTabChanged,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return _buildSearch();
      case 2:
        return _buildNews();
      case 3:
        return _buildProfile();
      default:
        return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Investment Summary Cards
              Row(
                children: [
                  Expanded(
                    child: PortfolioSummaryCard(
                      title: AppStrings.totalValue,
                      value: AppStrings.sampleTotalValue,
                      valueColor: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: PortfolioSummaryCard(
                      title: AppStrings.todaysGain,
                      value: AppStrings.sampleTodaysGain,
                      valueColor: AppColors.profit,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spaceXL),

              // Portfolios Section
              Text(AppStrings.portfolios, style: AppTextStyles.h3),

              const SizedBox(height: AppDimensions.spaceM),

              _buildPortfoliosList(),

              const SizedBox(height: AppDimensions.spaceXL),

              // Stocks Section
              Text(AppStrings.stocks, style: AppTextStyles.h3),

              const SizedBox(height: AppDimensions.spaceM),

              _buildStocksList(),

              const SizedBox(height: AppDimensions.spaceXXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfoliosList() {
    return Column(
      children: [
        StockCard(
          symbol: AppStrings.portfolio1,
          companyName: AppStrings.techStocks,
          currentPrice: AppStrings.samplePortfolio1Value,
          change: null,
          changePercentage: null,
          icon: Icons.folder_outlined,
          onTap: () {
            // TODO: Navigate to portfolio detail
          },
        ),
        const SizedBox(height: AppDimensions.spaceS),
        StockCard(
          symbol: AppStrings.portfolio2,
          companyName: AppStrings.energyStocks,
          currentPrice: AppStrings.samplePortfolio2Value,
          change: null,
          changePercentage: null,
          icon: Icons.folder_outlined,
          onTap: () {
            // TODO: Navigate to portfolio detail
          },
        ),
      ],
    );
  }

  Widget _buildStocksList() {
    return Column(
      children: [
        StockCard(
          symbol: AppStrings.tech,
          companyName: AppStrings.technologyInc,
          currentPrice: AppStrings.sampleTechValue,
          change: '+\$234.56',
          changePercentage: '+12.5%',
          icon: Icons.trending_up,
          onTap: () {
            // TODO: Navigate to stock detail
          },
        ),
        const SizedBox(height: AppDimensions.spaceS),
        StockCard(
          symbol: AppStrings.energy,
          companyName: AppStrings.energyCorp,
          currentPrice: AppStrings.sampleEnergyValue,
          change: '-\$45.12',
          changePercentage: '-3.5%',
          icon: Icons.trending_down,
          onTap: () {
            // TODO: Navigate to stock detail
          },
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return const Center(child: Text('Search Screen', style: AppTextStyles.h2));
  }

  Widget _buildNews() {
    return const Center(child: Text('News Screen', style: AppTextStyles.h2));
  }

  Widget _buildProfile() {
    return const Center(child: Text('Profile Screen', style: AppTextStyles.h2));
  }
}
