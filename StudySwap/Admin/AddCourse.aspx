<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddCourse.aspx.cs" Inherits="StudySwap.Admin.AddCourse" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Courses
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-wrap {
            max-width: 1400px;
            margin: 25px auto;
            padding: 0 20px;
        }

        .page-title {
            font-size: 22px;
            font-weight: 700;
            margin: 0 0 18px 0;
            color: #222;
        }

        /* ---- 2-column layout ---- */
        .two-col {
            display: grid;
            grid-template-columns: 380px 1fr;   /* left fixed, right flexible */
            gap: 22px;
            align-items: start;
        }
        @media (max-width: 900px) {
            .two-col { grid-template-columns: 1fr; }
        }

        /* ---- Card ---- */
        .card {
            background: #fff;
            border: 1px solid #e3e3e3;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .card h2 {
            margin: 0 0 16px 0;
            font-size: 17px;
            color: #0078d4;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 8px;
        }

        /* ---- Form ---- */
        .form-row { margin-bottom: 12px; }
        .form-row label {
            display: block;
            font-weight: 600;
            font-size: 13px;
            margin-bottom: 4px;
            color: #333;
        }
        .form-row input[type=text],
        .form-row select {
            width: 100%;
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
            background: #fff;
        }
        .form-row input[type=text]:focus,
        .form-row select:focus {
            outline: none;
            border-color: #0078d4;
            box-shadow: 0 0 0 2px rgba(0,120,212,0.15);
        }

        .chk-row { margin: 14px 0; }
        .chk-row label { font-weight: 600; font-size: 13px; }

        .msg {
            display: block;
            margin: 10px 0 14px 0;
            font-weight: 600;
            font-size: 13px;
            padding: 8px 10px;
            border-radius: 5px;
            background: #f6f6f6;
        }
        .msg:empty { display: none; }

        /* ---- Buttons ---- */
        .btn-row { margin-top: 18px; }
        .btn {
            padding: 9px 20px;
            margin-right: 8px;
            background: #0078d4;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }
        .btn:hover { background: #005a9e; }
        .btn-cancel { background: #888; }
        .btn-cancel:hover { background: #666; }

        /* ---- Grid ---- */
        .grid-wrap { overflow-x: auto; }
        .grid table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }
        .grid th, .grid td {
            border: 1px solid #e1e1e1;
            padding: 8px 10px;
            text-align: left;
        }
        .grid th {
            background: #f5f7fa;
            color: #333;
            font-weight: 700;
        }
        .grid tr:nth-child(even) td { background: #fafbfc; }
        .grid tr:hover td { background: #eef6fd; }
        .grid a { color: #0078d4; text-decoration: none; font-weight: 600; }
        .grid a:hover { text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="page-wrap">
    <h1 class="page-title">Manage Courses</h1>

    <div class="two-col">

        <!-- ================= LEFT: Add / Edit form ================= -->
        <div class="card">
            <h2><asp:Literal ID="litFormTitle" runat="server" Text="Add New Course" /></h2>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

            <asp:HiddenField ID="hfCourseID" runat="server" Value="0" />

            <div class="form-row">
                <label>Department</label>
                <asp:DropDownList ID="ddlDepartment" runat="server" />
            </div>
            <div class="form-row">
                <label>Course Name</label>
                <asp:TextBox ID="txtCourseName" runat="server" MaxLength="200" placeholder="e.g. B.Sc Computer Science" />
            </div>
            <div class="form-row">
                <label>Course Code</label>
                <asp:TextBox ID="txtCourseCode" runat="server" MaxLength="50" placeholder="e.g. BSC-CS" />
            </div>
            <div class="form-row">
                <label>Semester</label>
                <asp:TextBox ID="txtSemester" runat="server" MaxLength="50" placeholder="e.g. 1st / 4th" />
            </div>

            <div class="chk-row">
                <asp:CheckBox ID="chkIsActive" runat="server" Checked="true" Text=" Is Active" />
            </div>

            <div class="btn-row">
                <asp:Button ID="btnSave" runat="server" Text="Save Course"
                    CssClass="btn" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                    CssClass="btn btn-cancel" OnClick="btnCancel_Click"
                    CausesValidation="false" Visible="false" />
            </div>
        </div>

        <!-- ================= RIGHT: Grid ================= -->
        <div class="card">
            <h2>Existing Courses</h2>

            <div class="grid-wrap grid">
                <asp:GridView ID="gvCourses" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="CourseID" AllowPaging="True" PageSize="10"
                    GridLines="None"
                    OnPageIndexChanging="gvCourses_PageIndexChanging"
                    OnRowCommand="gvCourses_RowCommand"
                    OnRowDeleting="gvCourses_RowDeleting"
                    PagerStyle-HorizontalAlign="Center">
                    <Columns>
                        <asp:BoundField DataField="CourseID"     HeaderText="ID" />
                        <asp:BoundField DataField="DepartmentName" HeaderText="Department" />
                        <asp:BoundField DataField="CourseName"   HeaderText="Course Name" />
                        <asp:BoundField DataField="CourseCode"   HeaderText="Code" />
                        <asp:BoundField DataField="Semester"     HeaderText="Semester" />
                        <asp:CheckBoxField DataField="IsActive"  HeaderText="Active" ReadOnly="true" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server"
                                    CommandName="EditCourse"
                                    CommandArgument='<%# Eval("CourseID") %>'
                                    Text="Edit" />
                                &nbsp;|&nbsp;
                                <asp:LinkButton ID="lnkDelete" runat="server"
                                    CommandName="Delete"
                                    CommandArgument='<%# Eval("CourseID") %>'
                                    Text="Delete"
                                    OnClientClick="return confirm('Delete this course?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>
</div>

</asp:Content>