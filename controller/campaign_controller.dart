import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/api/api_checker.dart';
import 'package:sixam_mart/data/model/response/basic_campaign_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/repository/campaign_repo.dart';
import 'package:get/get.dart';

class CampaignController extends GetxController implements GetxService {
  final CampaignRepo campaignRepo;
  CampaignController({required this.campaignRepo});

  List<BasicCampaignModel>? _basicCampaignList;
  BasicCampaignModel? _campaign;
  List<Item>? _itemCampaignList;
  int _currentIndex = 0;

  List<BasicCampaignModel>? get basicCampaignList => _basicCampaignList;
  BasicCampaignModel? get campaign => _campaign;
  List<Item>? get itemCampaignList => _itemCampaignList;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if(notify) {
      update();
    }
  }

  void itemCampaignNull(){
    _itemCampaignList = null;
  }

  Future<void> getBasicCampaignList(bool reload, {bool selfReload = false}) async {
    if(_basicCampaignList == null || reload) {
      Response response = await campaignRepo.getBasicCampaignList();
      if (response.statusCode == 200) {
        _basicCampaignList = [];
        response.body.forEach((campaign) => _basicCampaignList!.add(BasicCampaignModel.fromJson(campaign)));
      } else {
        ApiChecker.checkApi(response);
      }
      update();
      if (!selfReload) {
        await campaignRepo.updateBasicCampaignList();
        await getBasicCampaignList(reload, selfReload: true);
      }
    }
  }

  Future<void> getBasicCampaignDetails(int? campaignID, {bool selfReload = false}) async {
    _campaign = null;
    Response response = await campaignRepo.getCampaignDetails(campaignID.toString());
    if (response.statusCode == 200) {
      _campaign = BasicCampaignModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
    if (!selfReload) {
      await campaignRepo.updateCampaignDetails(campaignID.toString());
      await getBasicCampaignDetails(campaignID, selfReload: true);
    }
  }

  Future<void> getItemCampaignList(bool reload, {bool selfReload = false}) async {
    if(_itemCampaignList == null || reload) {
      int? moduleID = Get.find<SplashController>().module?.id;
       if(moduleID!=null){
      Response response = await campaignRepo.getItemCampaignList(moduleID.toString());
      if (response.statusCode == 200) {
        _itemCampaignList = [];
        List<Item> campaign = [];
        response.body.forEach((camp) => campaign.add(Item.fromJson(camp)));
        for (var c in campaign) {
          if(!Get.find<SplashController>().getModuleConfig(c.moduleType).newVariation!
              || c.variations!.isEmpty || c.foodVariations!.isNotEmpty) {
            _itemCampaignList!.add(c);
          }
        }
      } else {
        print("DDDDDDDDDDDDDDw ${response.body}  ${selfReload}");
        ApiChecker.checkApi(response);
      }
      update();
      if (!selfReload) {
        await campaignRepo.updateItemCampaignList(moduleID.toString());
        await getItemCampaignList(reload, selfReload: true);
      }
    }
  }
  }

}