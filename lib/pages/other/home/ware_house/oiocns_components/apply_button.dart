import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplyButton extends StatelessWidget {
  final String url;
  final String applyName;
  final VoidCallback? onTap;
  const ApplyButton({
    Key? key,
    String? url,
    String? applyName, this.onTap,
  })  : url = url ?? 'http://anyinone.com:800/img/logo/logo3.jpg',
        applyName = applyName ?? '资产管理',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 82.w,
      margin: EdgeInsets.only(left: 32.w),
      decoration: const BoxDecoration(
          // color: Colors.white,
          ),
      child: GestureDetector(
        onTap:onTap, //点击
        onDoubleTap: () => print("DoubleTap"), //双击
        onLongPress: () => print("LongPress"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(27.w)),
                  color: Colors.black,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(url)),
                )),
            Text(
              applyName,
              maxLines: 1,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color.fromARGB(255, 52, 52, 54),
                overflow: TextOverflow.ellipsis
                // color: Colors.black
              ),
            )
          ],
        ), //长按
      ),
    );
  }
}
