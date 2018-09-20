# UITextField-Input-Limit
Alphanumeric limit now supports plain text, integer, and decimal places


# UITextField 输入限制
支持普通文本，整数，小数位数限制，
## 用法：
### 1.普通文本字数限制
textField.maxLength = 10
### 2.整数输入位数限制 （当设置了整数位数时表明支持 小数 没有设置小数位则默认支持2位,当然需要设置UIKeyboardTypeDecimalPad）
textField.maxIntLength = 6 
### 3.小数位数输入限制
textField.maxDecimalLength = 4
#### 特点 设置
