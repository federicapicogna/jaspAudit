// Copyright (C) 2013-2018 University of Amsterdam
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

// When making changes to this file always mention @koenderks as a
// reviewer in the Pull Request

import QtQuick
import QtQuick.Layouts
import JASP
import JASP.Controls

import "./common"	as Common

Form 
{
	columns: 							1
	info:								qsTr("The fairness measures analysis enables the user to assess fairness and discrimination regarding specific groups in the data in algorithmic decision-making systems. Considering a certain positive class in the data, fairness -or discrimination- can be quantified using model-agnostic fairness metrics. ")

	VariablesForm
	{
		preferredHeight:				jaspTheme.smallDefaultVariablesFormHeight

		AvailableVariablesList
		{
			name: 						"variablesFormFairness"
		}
		AssignedVariablesList
		{
			name: 						"target"
			title: 						qsTr("Ground truth information")
			singleVariable:				true
			allowedColumns:				["nominal"]
			minLevels:					2
			info:						qsTr("In this column, the ground truth information (i.e., the target to be predicted) variable should be entered.")
		}
		AssignedVariablesList
		{
			name: 						"predictions"
			title: 						qsTr("Predictions")
			singleVariable:				true
			allowedColumns:				["nominal"]
			minLevels:					2
			info:						qsTr("In this column, the predictions of the algorithm should be entered.")
		}
		AssignedVariablesList
		{
			name: 						"protected"
			title: 						qsTr("Sensitive Attribute")
			singleVariable:				true
			allowedColumns:				["nominal"]
			minLevels:					2
			info:						qsTr("In this column, the protected (i.e., sensitive) attribute should be entered.")
		}
	}

	Group
	{
		CIField
		{
			name: 						"conf_level"
			label: 						qsTr("Confidence")
			info:						qsTr("The confidence level used. The confidence level is the complement of the audit risk: the risk that the user is willing to take to give an incorrect judgment about the population. For example, if you want to use an audit risk of 5%, this equals 95% confidence.")
		}

		DropDown
		{
			id:							metric
			name: 						"metric"
			label: 						qsTr("Fairness Measures")
			indexDefaultValue: 			0
			values: [
				{ label: qsTr("Predictive rate parity"),			value: "prp"},
				{ label: qsTr("Demographic parity"),				value: "dp"},
				{ label: qsTr("Proportional parity"),				value: "pp"},
				{ label: qsTr("Accuracy parity"),					value: "ap"},
				{ label: qsTr("False negative rate parity"),		value: "fnrp"},
				{ label: qsTr("False positive rate parity"),		value: "fprp"},
				{ label: qsTr("True positive rate parity"),			value: "tprp"},
				{ label: qsTr("Negative predicted value parity"),	value: "npvp"},
				{ label: qsTr("Specificity parity"), 				value: "sp"}
			]
			info:						qsTr("The type of fairness measure to compute and perform inference on.")
		}
	}

	Group 
	{
		title:							qsTr("Factor Levels")
		info:							qsTr("These options allow specification of the privileged group and the positive class.")

		DropDown
		{
			label: 						qsTr("Privileged group")
			name: 						"privileged"
			indexDefaultValue: 			0
			addEmptyValue: 				true
			placeholderText: 			qsTr("None")
			source: 					[ { name: "protected", use: "levels" } ]
			info:						qsTr("The privileged group refers to the class in the protected variable that historically or systematically experiences certain advantages, benefits, or privileges.")
		}

		DropDown
		{
			label: 						qsTr("Positive class")
			name: 						"positive"
			indexDefaultValue: 			0
			addEmptyValue: 				true
			placeholderText: 			qsTr("None")
			source: 					[ { name: "target", use: "levels" } ]
			info:						qsTr("The positive class in the target variable.")
		}
	}

	RadioButtonGroup
	{
		title: 							qsTr("Alt. Hypothesis")
		name: 							"alternative"
		info:							qsTr("Specify the alternative hypothesis.")

		RadioButton
		{
			text: 						qsTr("Unprivileged \u2260 Privileged")
			name: 						"two.sided"
			checked:					true
			info:						qsTr("Test the alternative hypothesis that the fairness metric of an unprivileged group is not equal to the fairness metric in the privileged group.")
		}

		RadioButton
		{
			text: 						qsTr("Unprivileged < Privileged")
			name: 						"less"
			info:						qsTr("Test the alternative hypothesis that the fairness metric of an unprivileged group is lower than the fairness metric in the privileged group.")
		}

		RadioButton
		{
			text: 						qsTr("Unprivileged > Privileged")
			name: 						"greater"
			info:						qsTr("Test the alternative hypothesis that the fairness metric of an unprivileged group is higher than the fairness metric in the privileged group.")
		}
	}

	Group
	{
		title: 							qsTr("Display")
		info:							qsTr("Specify options that have an effect on the look and feel of the audit report.")

		Row
		{
			CheckBox
			{
				id: 					explanatoryText
				text: 					qsTr("Explanatory text")
				name: 					"explanatoryText"
				checked: 				true
				info:					qsTr("When checked, enables explanatory text in the analysis to help interpret the procedure and the statistical results.")
			}

			HelpButton
			{
				helpPage:				"Audit/explanatoryText"
				toolTip: 				qsTr("Show explanatory text at each step of the analysis")
			}
		}
	}

	Section
	{
		title: 							qsTr("Report")
		columns: 						1

		Group
		{
			title: 						qsTr("Tables")
			info:						qsTr("Add additional tables about the evaluation to the report.")

			CheckBox
			{
				text:					qsTr("Confusion matrix")
				name:					"confusionTable"
				info:					qsTr("Produces the confusion matrix for each group.")

				CheckBox {
					text:				qsTr("Display proportions")
					name:				"confusionTableProportions"
					info:				qsTr("Displays proportions in the confusion table.")
				}
			}
		}

	}

	Section
	{
		columns:						1
		title: 							qsTr("Advanced")

		Group
		{
			title:						qsTr("Advanced")

			IntegerField
			{
				name:					"seed"
				label:					qsTr("Seed")
				defaultValue:			Math.floor(Math.random() * 1000) // Init with random integer in [1,...,999]
				min:					-999
				max:					999
				info:					qsTr("Selects the seed for the random number generator in order to reproduce results.")
			}
		}
	}

	Common.DownloadReport { }
}
