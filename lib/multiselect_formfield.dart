library multiselect_formfield;

import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';

class MultiSelectFormField extends FormField<dynamic> {
  final Widget title;
  final Widget hintWidget;
  final bool required;
  final String errorText;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function change;
  final Function open;
  final Function close;
  final Widget leading;
  final Widget trailing;
  final String okButtonLabel;
  final String cancelButtonLabel;
  final Color fillColor;
  final InputBorder border;
  final TextStyle chipLabelStyle;
  final Color chipBackGroundColor;
  final TextStyle dialogTextStyle;
  final ShapeBorder dialogShapeBorder;
  final Color checkBoxCheckColor;
  final Color checkBoxActiveColor;
  final bool enabled;
  final EdgeInsets contentPadding;
  final String label;
  final String displayString;
  final TextStyle dialogCancelStyle;
  final TextStyle dialogOKStyle;

  MultiSelectFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      dynamic initialValue,
      bool autovalidate = false,
      this.title = const Text('Title'),
      this.hintWidget = const Text('Tap to select one or more'),
      this.required = false,
      this.errorText = 'Please select one or more options',
      this.leading,
      this.dataSource,
      this.textField,
      this.valueField,
      this.change,
      this.open,
      this.close,
      this.okButtonLabel = 'OK',
      this.cancelButtonLabel = 'CANCEL',
      this.fillColor,
      this.border,
      this.trailing,
      this.chipLabelStyle,
      this.enabled = true,
      this.chipBackGroundColor,
      this.dialogTextStyle = const TextStyle(),
      this.dialogShapeBorder = const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      this.checkBoxActiveColor,
      this.checkBoxCheckColor,
      this.label,
      this.displayString,
      this.dialogCancelStyle,
      this.dialogOKStyle,
      this.contentPadding = const EdgeInsets.all(16)})
      : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autovalidate,
          builder: (FormFieldState<dynamic> state) {
            return Opacity(
                opacity: enabled ? 1.0 : 0.5,
                child: InkWell(
                  onTap: !enabled
                      ? null
                      : () async {
                          List initialSelected = state.value;
                          if (initialSelected == null) {
                            initialSelected = List();
                          }

                          final items = List<MultiSelectDialogItem<dynamic>>();
                          dataSource.forEach((item) {
                            items.add(MultiSelectDialogItem(
                                item[valueField], item[textField]));
                          });

                          List selectedValues = await showDialog<List>(
                            context: state.context,
                            builder: (BuildContext context) {
                              return MultiSelectDialog(
                                  title: title,
                                  okButtonLabel: okButtonLabel,
                                  cancelButtonLabel: cancelButtonLabel,
                                  items: items,
                                  initialSelectedValues: initialSelected,
                                  labelStyle: dialogTextStyle,
                                  dialogShapeBorder: dialogShapeBorder,
                                  checkBoxActiveColor: checkBoxActiveColor,
                                  checkBoxCheckColor: checkBoxCheckColor,
                                  dialogCancelStyle: dialogCancelStyle,
                                  dialogOKStyle: dialogOKStyle);
                            },
                          );

                          if (selectedValues != null) {
                            state.didChange(selectedValues);
                            state.save();
                          }
                        },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: label,
                      contentPadding: contentPadding,
                      filled: true,
                      errorText: state.hasError ? state.errorText : null,
                      errorMaxLines: 4,
                      fillColor:
                          fillColor ?? Theme.of(state.context).canvasColor,
                      border: border ?? UnderlineInputBorder(),
                    ),
                    isEmpty: state.value == null || state.value == '',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        state.value != null && state.value.length > 0
                            ? Flexible(
                                child: Text(
                                  displayString ??
                                      (state.value as List).join(', '),
                                ),
                              )
                            : new Container(
                                padding: EdgeInsets.only(top: 4),
                                child: hintWidget,
                              ),
                        Row(
                          children: [
                            if (required)
                              Padding(
                                padding: EdgeInsets.only(top: 5, right: 5),
                                child: Text(
                                  ' *',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black87,
                              size: 25.0,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ));
          },
        );
}
