class VerifyHelper {
  static String content = '''
class VerifyHelper {
  /// Retrun true if [s] is empty, otherwise false.
  static bool empty(String s) {
    if (null == s) return true;
    return "" == s;
  }

  /// Retrun true if [s] is not empty, otherwise false.
  static bool notEmpty(String s) {
    return !empty(s);
  }

  /// Retrun true if [n] = 0, otherwise false.
  ///
  /// [n] accept double and int
  static bool zero(num n) {
    if (null == n) return true;
    return 0 == n;
  }

  /// Retrun true if [n] != 0, otherwise false.
  ///
  /// [n] accept double and int
  static bool notZero(num n) {
    return !zero(n);
  }

  /// Retrun true if [n] > 0, otherwise false.
  ///
  /// [n] accept double and int
  static bool positive(num n) {
    return n > 0;
  }

  /// Retrun true if [n] > 0, otherwise false.
  ///
  /// [n] only accept int
  static bool positiveInt(int n) {
    return positive(n);
  }

  /// Retrun true if [n] > 0, otherwise false.
  ///
  /// [n] only accept double
  static bool positiveDouble(double n) {
    return positive(n);
  }

  /// Retrun true if [n] <= 0, otherwise false.
  ///
  /// [n] accept double and int
  static bool notPositive(num n) {
    return !positive(n);
  }

  /// Retrun true if [n] <= 0, otherwise false.
  ///
  /// [n] only accept int
  static bool notPositiveInt(int n) {
    return notPositive(n);
  }

  /// Retrun true if [n] <= 0, otherwise false.
  ///
  /// [n] only accept double
  static bool notPositiveDouble(double n) {
    return notPositive(n);
  }

  /// Retrun true if [n] < 0, otherwise false.
  ///
  /// [n] accept double and int
  static bool negative(num n) {
    return n < 0;
  }

  /// Retrun true if [n] < 0, otherwise false.
  ///
  /// [n] only accept int
  static bool negativeInt(int n) {
    return negative(n);
  }

  /// Retrun true if [n] < 0, otherwise false.
  ///
  /// [n] only accept double
  static bool negativeDouble(double n) {
    return negative(n);
  }

  /// Retrun true if [n] >= 0, otherwise false.
  ///
  /// [n] accept double and int
  static bool notNegative(num n) {
    return !negative(n);
  }

  /// Retrun true if [n] >= 0, otherwise false.
  ///
  /// [n] only accept int
  static bool notNegativeInt(int n) {
    return notNegative(n);
  }

  /// Retrun true if [n] >= 0, otherwise false.
  ///
  /// [n] only accept double
  static bool notNegativeDouble(double n) {
    return notNegative(n);
  }

  /// Retrun true if the length of [s] between [min] and [max], otherwise false.
  ///
  /// [min] min value
  ///
  /// [max] max value
  static bool lengthBetween(String s, int min, int max) {
    return s.length >= min && s.length <= max;
  }

  /// Retrun true if the length of [s] not between [min] and [max], otherwise false.
  ///
  /// [min] min value
  ///
  /// [max] max value
  static bool lengthNotBetween(String s, int min, int max) {
    return !lengthBetween(s, min, max);
  }

  /// Retrun true if the length of [s] equal to [length], otherwise false.
  ///
  /// [length] length value
  static bool lengthEq(String s, int length) {
    return s.length == length;
  }

  /// Retrun true if the length of [s] not equal to [length], otherwise false.
  ///
  /// [length] length value
  static bool lengthNotEq(String s, int length) {
    return !lengthEq(s, length);
  }

  /// Retrun true if the value of [i] between [min] and [max], otherwise false.
  ///
  /// [min] min value
  ///
  /// [max] max value
  static bool valueBetween(int i, int min, int max) {
    return i >= min && i <= max;
  }

  /// Retrun true if the value of [i] not between [min] and [max], otherwise false.
  ///
  /// [min] min value
  ///
  /// [max] max value
  static bool valueNotBetween(int i, int min, int max) {
    return !valueBetween(i, min, max);
  }

  /// Retrun true if the length of [i] equal to [value], otherwise false.
  ///
  /// [value] value
  static bool valueEq(int s, int value) {
    return s == value;
  }

  /// Retrun true if the length of [i] not equal to [value], otherwise false.
  ///
  /// [value] value
  static bool valueNotEq(int s, int value) {
    return !valueEq(s, value);
  }

  /// Retrun true if [s] is email, otherwise false.
  static bool email(String s) {
    return true;
  }

  /// Retrun true if [s] is not email, otherwise false.
  static bool notEmail(String s) {
    return !email(s);
  }

  /// Retrun true if [s] is chinese mobile, otherwise false.
  ///
  /// China Mobile：134 135 136 137 138 139 147 148 150 151 152 157 158 159 172 178 182 183 184 187 188 195 198
  ///
  /// China Unicom：130 131 132 145 146 155 156 166 167 171 175 176 185 186 196
  ///
  /// China Telecom：133 149 153 173 174 177 180 181 189 191 193 199
  ///
  /// Virtual Network Operator: 162 165 167 170 171
  ///
  /// start with 13：(0-9)（134 135 136 137 138 139 130 131 132 133）
  ///
  /// start with 14：(5-9)（147 148 145 146 149）
  ///
  /// start with 15：(0-3|5-9)（150 151 152 157 158 159 155 156 153）
  ///
  /// start with 16：(6-7)（166 167）
  ///
  /// start with 17：(1-8)（172 178 171 175 176 173 174 177）
  ///
  /// start with 18：(0-9)（182 183 184 187 188 185 186 180 181 189）
  ///
  /// start with 19：(1|3|5|6|8|9)（195 198 196 191 193 199）
  ///
  /// @see {https://www.qqzeng.com/article/phone.html}
  static bool chsMobile(String s) {
    String regex =
        "((13[0-9])|(14[5-9])|(15([0-3]|[5-9]))|(16[6-7])|(17[1-8])|(18[0-9])|(19[1|3|5|6|8|9]))\\d{8}";
    RegExp exp = new RegExp(regex);

    return exp.hasMatch(s);
  }

  /// Retrun true if [s] is not chinese mobile, otherwise false.
  static bool notChsMobile(String s) {
    return !chsMobile(s);
  }

  /// Retrun true if [s] is chinese IdCard, otherwise false.
  static bool chsIdCard(String s) {
    bool isMatch = RegExp(r"\d{17}[\d|x|X]|\d{15}").hasMatch(s);

    if (isMatch && s.length == 18) {
      List idCardWi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2];
      List<int> idCardY = [1,0,10,9,8,7,6,5,4,3,2];

      int idCardWiSum = 0;
      for (var i = 0; i < 17; i++) {
        idCardWiSum += int.parse(s[i]) * idCardWi[i];
      }

      int idCardMod = idCardWiSum % 11;
      int idCardLast = idCardY[idCardMod];

      isMatch = (idCardLast == 10 && (s[17] == 'X' || s[17] == 'x')) ||
          (idCardLast != 10 && (s[17] == idCardLast.toString()));
    }

    return isMatch;
  }

  /// Retrun true if [s] is not chinese IdCard, otherwise false.
  static bool notChsIdCard(String s) {
    return !chsIdCard(s);
  }

  /// Retrun true if [s] char is letter, otherwise false.
  static bool alpha(String s) {
    return !RegExp(r"[^a-zA-Z]+").hasMatch(s);
  }

  /// Retrun true if [s] char is not letter, otherwise false.
  static bool notAlpha(String s) {
    return !alpha(s);
  }

  /// Retrun true if [s] char is letter,number, otherwise false.
  static bool alphaNum(String s) {
    return !RegExp(r"[^a-zA-Z0-9]+").hasMatch(s);
  }

  /// Retrun true if [s] char is not letter,number, otherwise false.
  static bool notAlphaNum(String s) {
    return !alphaNum(s);
  }

  /// Retrun true if [s] char is letter,number,-,_, otherwise false.
  static bool alphaNumDash(String s) {
    return !RegExp(r"[^a-zA-Z0-9\\-\\_]+").hasMatch(s);
  }

  /// Retrun true if [s] char is not letter,number,-,_, otherwise false.
  static bool notAlphaNumDash(String s) {
    return !alphaNumDash(s);
  }

  /// Retrun true if [s] char is chinese text, otherwise false.
  static bool chs(String s) {
    return !RegExp(r"[^\\u4e00-\\u9fa5]+").hasMatch(s);
  }

  /// Retrun true if [s] char is not chinese text, otherwise false.
  static bool notChs(String s) {
    return !chs(s);
  }

  /// Retrun true if [s] char is chinese text,letter, otherwise false.
  static bool chsAlpha(String s) {
    return !RegExp(r"[^a-zA-Z\\u4e00-\\u9fa5]+").hasMatch(s);
  }

  /// Retrun true if [s] char is not chinese text,letter, otherwise false.
  static bool notChsAlpha(String s) {
    return !chsAlpha(s);
  }

  /// Retrun true if [s] char is chinese text,letter,number, otherwise false.
  static bool chsAlphaNum(String s) {
    return !RegExp(r"[^a-zA-Z0-9\\u4e00-\\u9fa5]+").hasMatch(s);
  }

  /// Retrun true if [s] char is not chinese text,letter,number, otherwise false.
  static bool notChsAlphaNum(String s) {
    return !chsAlphaNum(s);
  }

  /// Retrun true if [s] char is chinese text,letter,number,-,_, otherwise false.
  static bool chsAlphaNumDash(String s) {
    return !RegExp(r"[^a-zA-Z0-9\\-\\_\\u4e00-\\u9fa5]+").hasMatch(s);
  }

  /// Retrun true if [s] char is not chinese text,letter,number,-,_, otherwise false.
  static bool notChsAlphaNumDash(String s) {
    return !chsAlphaNumDash(s);
  }
}
  ''';
}
