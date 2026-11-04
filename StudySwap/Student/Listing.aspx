<%@ Page Title="Create Listing" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" CodeBehind="Listing.aspx.cs" Inherits="StudySwap.Student.Listing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .listing-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 3rem 1rem;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .listing-wrapper {
            max-width: 900px;
            margin: 0 auto;
        }

        .listing-header {
            text-align: center;
            margin-bottom: 2.5rem;
            animation: fadeInDown 0.6s ease-out;
        }

        .listing-header h1 {
            color: white;
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }

        .listing-header p {
            color: rgba(255,255,255,0.9);
            font-size: 1.1rem;
        }

        .listing-form {
            background: white;
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: fadeInUp 0.6s ease-out;
            position: relative;
            overflow: hidden;
        }

        .listing-form::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #667eea, #764ba2, #f093fb, #4facfe);
            background-size: 300% 100%;
            animation: gradientShift 3s ease infinite;
        }

        @keyframes gradientShift {
            0%, 100% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 3px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .section-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
            transition: color 0.3s;
        }

        .required::after {
            content: ' *';
            color: #e74c3c;
        }

        .form-control {
            width: 100%;
            padding: 0.875rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafafa;
            font-family: inherit;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .form-control:hover {
            border-color: #b0b0b0;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 120px;
            font-family: inherit;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }

        .checkbox-group:hover {
            background: #e9ecef;
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #667eea;
        }

        .checkbox-group label {
            margin: 0;
            cursor: pointer;
            user-select: none;
        }

        .alert {
            padding: 1rem 1.25rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            animation: slideIn 0.4s ease-out;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-icon {
            font-size: 1.5rem;
        }

        .btn-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            flex: 1;
            padding: 1rem 2rem;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 25px rgba(102, 126, 234, 0.5);
        }

        .btn-submit:active {
            transform: translateY(-1px);
        }

        .btn-cancel {
            background: white;
            color: #7f8c8d;
            border: 2px solid #e0e0e0;
        }

        .btn-cancel:hover {
            background: #f8f9fa;
            border-color: #95a5a6;
        }

        .helper-text {
            font-size: 0.85rem;
            color: #7f8c8d;
            margin-top: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .helper-icon {
            color: #3498db;
        }

        .price-input-wrapper {
            position: relative;
        }

        .currency-symbol {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 600;
            color: #2c3e50;
            font-size: 1.1rem;
        }

        .price-input-wrapper .form-control {
            padding-left: 2.5rem;
        }

        .listing-type-cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
        }

        @media (max-width: 768px) {
            .listing-type-cards {
                grid-template-columns: 1fr;
            }
        }

        .type-card {
            padding: 1.5rem;
            border: 3px solid #e0e0e0;
            border-radius: 16px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: white;
            position: relative;
            overflow: hidden;
        }

        .type-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
            opacity: 0;
            transition: opacity 0.3s;
        }

        .type-card:hover::before {
            opacity: 1;
        }

        .type-card:hover {
            border-color: #667eea;
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.25);
        }

        .type-card.selected {
            border-color: #667eea;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.2);
        }

        .type-card.selected .type-card-check {
            display: block;
        }

        .type-card-check {
            display: none;
            position: absolute;
            top: 10px;
            right: 10px;
            width: 30px;
            height: 30px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            color: white;
            font-size: 1rem;
            line-height: 30px;
            box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
        }

        .type-card-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            position: relative;
            z-index: 1;
        }

        .type-card-title {
            font-weight: 700;
            color: #2c3e50;
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
            position: relative;
            z-index: 1;
        }

        .type-card-desc {
            font-size: 0.9rem;
            color: #7f8c8d;
            position: relative;
            z-index: 1;
        }

        .progress-bar {
            height: 6px;
            background: #e0e0e0;
            border-radius: 3px;
            margin-bottom: 2rem;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            width: 0%;
            transition: width 0.3s ease;
        }

        .char-counter {
            text-align: right;
            font-size: 0.85rem;
            color: #95a5a6;
            margin-top: 0.25rem;
        }

        /* THREE IMAGES UPLOAD STYLING */
        .three-images-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-top: 1rem;
        }

        @media (max-width: 768px) {
            .three-images-container {
                grid-template-columns: 1fr;
            }
        }

        .image-upload-box {
            position: relative;
            border: 3px dashed #e0e0e0;
            border-radius: 16px;
            padding: 2rem 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: #fafafa;
            min-height: 250px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .image-upload-box:hover {
            border-color: #667eea;
            background: rgba(102, 126, 234, 0.05);
            transform: scale(1.02);
        }

        .image-upload-box.has-image {
            border-color: #667eea;
            background: white;
        }

        .upload-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }

        .upload-icon {
            font-size: 3rem;
            color: #95a5a6;
        }

        .upload-label {
            font-size: 0.9rem;
            color: #7f8c8d;
            font-weight: 600;
        }

        .upload-sublabel {
            font-size: 0.75rem;
            color: #95a5a6;
        }

        .image-preview {
            display: none;
            position: relative;
            width: 100%;
            height: 100%;
        }

        .image-preview.active {
            display: block;
        }

        .preview-img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 12px;
        }

        .remove-image-btn {
            position: absolute;
            top: -10px;
            right: -10px;
            background: #e74c3c;
            color: white;
            border: 3px solid white;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            cursor: pointer;
            font-size: 1.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .remove-image-btn:hover {
            background: #c0392b;
            transform: scale(1.1);
        }

        .image-number-badge {
            position: absolute;
            bottom: 10px;
            left: 10px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }

        .upload-note {
            margin-top: 1.5rem;
            padding: 1rem;
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            font-size: 0.85rem;
            color: #856404;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .validation-message {
            color: #e74c3c;
            font-size: 0.85rem;
            margin-top: 0.5rem;
            display: none;
        }

        .validation-message.show {
            display: block;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="listing-container">
        <div class="listing-wrapper">
            <!-- Header -->
            <div class="listing-header">
                <h1>📦 Create New Selling & Exchnage Listing</h1>
                <p>Share your study materials and help fellow students save money</p>
            </div>

            <!-- Form -->
            <div class="listing-form">
                <!-- Progress Bar -->
                <div class="progress-bar">
                    <div class="progress-fill" id="progressFill"></div>
                </div>

                <!-- Alert Message -->
                <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert">
                    <span class="alert-icon">✓</span>
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </asp:Panel>

                <!-- Basic Information Section -->
                <div class="form-section">
                    <div class="section-title">
                        <div class="section-icon">📋</div>
                        <span>Basic Information</span>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="required">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Category --</asp:ListItem>
 
                            </asp:DropDownList>
                        </div>

                      <%--  <div class="form-group">
                            <label class="required">Course/Subject</label>
                            <asp:DropDownList ID="ddlCourse" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Course --</asp:ListItem>
                       
                            </asp:DropDownList>
                        </div>--%>

                        <div class="form-group full-width">
                            <label class="required">Item Title</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                                placeholder="e.g., Introduction to Algorithms (3rd Edition)"
                                MaxLength="100" onkeyup="updateCharCounter(this, 'titleCounter', 100)"></asp:TextBox>
                            <div class="char-counter">
                                <span id="titleCounter">0/100</span>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <label class="required">Description</label>
                            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"
                                Rows="5" CssClass="form-control"
                                placeholder="Describe the condition, edition, and any additional details about the item..."
                                MaxLength="500" onkeyup="updateCharCounter(this, 'descCounter', 500)"></asp:TextBox>
                            <div class="char-counter">
                                <span id="descCounter">0/500</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Item Details Section -->
                <div class="form-section">
                    <div class="section-title">
                        <div class="section-icon">🔍</div>
                        <span>Item Details</span>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label class="required">Condition</label>
                            <asp:DropDownList ID="ddlCondition" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">-- Select Condition --</asp:ListItem>
                                <asp:ListItem Value="New">New (Unused)</asp:ListItem>
                                <asp:ListItem Value="Like New">Like New (Minimal use)</asp:ListItem>
                                <asp:ListItem Value="Good">Good (Light wear)</asp:ListItem>
                                <asp:ListItem Value="Fair">Fair (Moderate wear)</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label>ISBN/Product Code (Optional)</label>
                            <asp:TextBox ID="txtISBN" runat="server" CssClass="form-control"
                                placeholder="Enter ISBN or product code"></asp:TextBox>
                        </div>
                    </div>
                </div>

                <!-- THREE IMAGES UPLOAD SECTION -->
                <div class="form-section">
                    <div class="section-title">
                        <div class="section-icon">📸</div>
                        <span>Product Images (Required: 3 Images)</span>
                    </div>

                    <div class="form-group full-width">
                        <label class="required">Upload Exactly 3 Photos</label>
                        
                        <div class="three-images-container">
                            <!-- Image 1 -->
                            <div class="image-upload-box" id="uploadBox1" onclick="triggerFileInput(1)">
                                <div class="upload-placeholder" id="placeholder1">
                                    <div class="upload-icon">📷</div>
                                    <div class="upload-label">Image 1</div>
                                    <div class="upload-sublabel">Click to upload</div>
                                </div>
                                <div class="image-preview" id="preview1">
                                    <img src="" alt="Preview 1" class="preview-img" id="previewImg1">
                                    <div class="image-number-badge">Image 1</div>
                                    <button type="button" class="remove-image-btn" onclick="removeImage(1, event)">×</button>
                                </div>
                            </div>

                            <!-- Image 2 -->
                            <div class="image-upload-box" id="uploadBox2" onclick="triggerFileInput(2)">
                                <div class="upload-placeholder" id="placeholder2">
                                    <div class="upload-icon">📷</div>
                                    <div class="upload-label">Image 2</div>
                                    <div class="upload-sublabel">Click to upload</div>
                                </div>
                                <div class="image-preview" id="preview2">
                                    <img src="" alt="Preview 2" class="preview-img" id="previewImg2">
                                    <div class="image-number-badge">Image 2</div>
                                    <button type="button" class="remove-image-btn" onclick="removeImage(2, event)">×</button>
                                </div>
                            </div>

                            <!-- Image 3 -->
                            <div class="image-upload-box" id="uploadBox3" onclick="triggerFileInput(3)">
                                <div class="upload-placeholder" id="placeholder3">
                                    <div class="upload-icon">📷</div>
                                    <div class="upload-label">Image 3</div>
                                    <div class="upload-sublabel">Click to upload</div>
                                </div>
                                <div class="image-preview" id="preview3">
                                    <img src="" alt="Preview 3" class="preview-img" id="previewImg3">
                                    <div class="image-number-badge">Image 3</div>
                                    <button type="button" class="remove-image-btn" onclick="removeImage(3, event)">×</button>
                                </div>
                            </div>
                        </div>

                        <!-- Hidden File Inputs -->
                        <asp:FileUpload ID="fuImage1" runat="server" Style="display: none;" 
                            accept="image/jpeg,image/jpg,image/png" onchange="handleImageUpload(1)" />
                        <asp:FileUpload ID="fuImage2" runat="server" Style="display: none;" 
                            accept="image/jpeg,image/jpg,image/png" onchange="handleImageUpload(2)" />
                        <asp:FileUpload ID="fuImage3" runat="server" Style="display: none;" 
                            accept="image/jpeg,image/jpg,image/png" onchange="handleImageUpload(3)" />

                        <div class="validation-message" id="imageValidation">
                            ⚠️ Please upload all 3 product images
                        </div>

                        <div class="upload-note">
                            📌 <strong>Important:</strong> All 3 images are required. Upload clear photos showing different angles of your product (front, back, and details).
                        </div>
                    </div>
                </div>

                <!-- Listing Type & Pricing Section -->
                <div class="form-section">
                    <div class="section-title">
                        <div class="section-icon">💰</div>
                        <span>Listing Type & Pricing</span>
                    </div>

                    <div class="form-group full-width">
                        <label class="required">What would you like to do?</label>
                        <div class="listing-type-cards">
                            <div class="type-card" onclick="selectListingType('Sell', this)">
                                <div class="type-card-check">✓</div>
                                <div class="type-card-icon">💵</div>
                                <div class="type-card-title">Sell</div>
                                <div class="type-card-desc">Set a price and sell your item</div>
                            </div>
                            <div class="type-card" onclick="selectListingType('Exchange', this)">
                                <div class="type-card-check">✓</div>
                                <div class="type-card-icon">🔄</div>
                                <div class="type-card-title">Exchange</div>
                                <div class="type-card-desc">Swap with another student's item</div>
                            </div>
                            <div class="type-card" onclick="selectListingType('Both', this)">
                                <div class="type-card-check">✓</div>
                                <div class="type-card-icon">🤝</div>
                                <div class="type-card-title">Both</div>
                                <div class="type-card-desc">Open to selling or exchanging</div>
                            </div>
                        </div>
                        <asp:HiddenField ID="hfListingType" runat="server" />
                        <asp:HiddenField ID="hfReplyID" runat="server" />

                    </div>

                    <div class="form-grid" id="pricingSection" style="display: none;">
                        <div class="form-group">
                            <label class="required">Selling Price</label>
                            <div class="price-input-wrapper">
                                <span class="currency-symbol">₹</span>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"
                                    placeholder="0" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Original Price (Optional)</label>
                            <div class="price-input-wrapper">
                                <span class="currency-symbol">₹</span>
                                <asp:TextBox ID="txtOriginalPrice" runat="server" CssClass="form-control"
                                    placeholder="0" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-group full-width">
                            <div class="checkbox-group">
                                <asp:CheckBox ID="chkNegotiable" runat="server" />
                                <label for="<%= chkNegotiable.ClientID %>">💬 Price is negotiable</label>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="btn-group">
                    <button type="button" class="btn btn-cancel" onclick="window.history.back();">
                        ✕ Cancel
                    </button>
                    <asp:Button ID="btnSubmit" runat="server" Text="🚀 Create Listing"
                        CssClass="btn btn-submit" OnClick="btnSubmit_Click" OnClientClick="return validateForm();" />
                </div>
            </div>
        </div>
    </div>
 

 <script>
     // Add this script section to your ASPX page after the listing-form closing div

     // Character counter
     function updateCharCounter(element, counterId, maxLength) {
         const counter = document.getElementById(counterId);
         const currentLength = element.value.length;
         counter.textContent = currentLength + '/' + maxLength;
         updateProgress();
     }

     // Listing type selection
     function selectListingType(type, element) {
         document.querySelectorAll('.type-card').forEach(card => {
             card.classList.remove('selected');
         });

         element.classList.add('selected');
         document.getElementById('<%= hfListingType.ClientID %>').value = type;

         const pricingSection = document.getElementById('pricingSection');

         if (type === 'Sell' || type === 'Both') {
             pricingSection.style.display = 'grid';
         } else if (type === 'Exchange') {
             pricingSection.style.display = 'none';
         }

         updateProgress();
     }

     // Trigger file input for specific image
     function triggerFileInput(imageNumber) {
         event.stopPropagation();
         let fileInputId;
         if (imageNumber === 1) {
             fileInputId = '<%= fuImage1.ClientID %>';
} else if (imageNumber === 2) {
    fileInputId = '<%= fuImage2.ClientID %>';
} else if (imageNumber === 3) {
             fileInputId = '<%= fuImage3.ClientID %>';
         }

    // Get the correct file upload control
    let fileInput;
    if (imageNumber === 1) {
        fileInput = document.getElementById('<%= fuImage1.ClientID %>');
    } else if (imageNumber === 2) {
        fileInput = document.getElementById('<%= fuImage2.ClientID %>');
    } else if (imageNumber === 3) {
        fileInput = document.getElementById('<%= fuImage3.ClientID %>');
         }

         if (fileInput) {
             fileInput.click();
         }
     }

     // Handle image upload and preview
     function handleImageUpload(imageNumber) {
         let fileInput;

         if (imageNumber === 1) {
             fileInput = document.getElementById('<%= fuImage1.ClientID %>');
    } else if (imageNumber === 2) {
        fileInput = document.getElementById('<%= fuImage2.ClientID %>');
    } else if (imageNumber === 3) {
        fileInput = document.getElementById('<%= fuImage3.ClientID %>');
         }

         if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
             return;
         }

         const file = fileInput.files[0];

         // Validate file type
         const validTypes = ['image/jpeg', 'image/jpg', 'image/png'];
         if (!validTypes.includes(file.type)) {
             alert('❌ Please upload only JPG, JPEG, or PNG images.');
             fileInput.value = '';
             return;
         }

         // Validate file size (5MB max)
         if (file.size > 5 * 1024 * 1024) {
             alert('❌ Image size must be less than 5MB.');
             fileInput.value = '';
             return;
         }

         // Show preview
         const reader = new FileReader();
         reader.onload = function (e) {
             const previewImg = document.getElementById('previewImg' + imageNumber);
             const preview = document.getElementById('preview' + imageNumber);
             const placeholder = document.getElementById('placeholder' + imageNumber);
             const uploadBox = document.getElementById('uploadBox' + imageNumber);

             previewImg.src = e.target.result;
             preview.classList.add('active');
             placeholder.style.display = 'none';
             uploadBox.classList.add('has-image');

             updateProgress();
             checkImageValidation();
         };
         reader.readAsDataURL(file);
     }

     // Remove image
     function removeImage(imageNumber, event) {
         event.stopPropagation();
         event.preventDefault();

         let fileInput;

         if (imageNumber === 1) {
             fileInput = document.getElementById('<%= fuImage1.ClientID %>');
    } else if (imageNumber === 2) {
        fileInput = document.getElementById('<%= fuImage2.ClientID %>');
    } else if (imageNumber === 3) {
        fileInput = document.getElementById('<%= fuImage3.ClientID %>');
         }

         if (fileInput) {
             fileInput.value = '';
         }

         const preview = document.getElementById('preview' + imageNumber);
         const placeholder = document.getElementById('placeholder' + imageNumber);
         const uploadBox = document.getElementById('uploadBox' + imageNumber);

         preview.classList.remove('active');
         placeholder.style.display = 'flex';
         uploadBox.classList.remove('has-image');

         updateProgress();
         checkImageValidation();
     }

     // Check if all 3 images are uploaded
     function checkImageValidation() {
         const fileInput1 = document.getElementById('<%= fuImage1.ClientID %>');
    const fileInput2 = document.getElementById('<%= fuImage2.ClientID %>');
    const fileInput3 = document.getElementById('<%= fuImage3.ClientID %>');

         const validation = document.getElementById('imageValidation');

         if (fileInput1.files.length > 0 && fileInput2.files.length > 0 && fileInput3.files.length > 0) {
             validation.classList.remove('show');
             return true;
         } else {
             validation.classList.add('show');
             return false;
         }
     }

     // Form validation before submit
     function validateForm() {
         let isValid = true;
         let errorMessage = '';

         // Check category
         const category = document.getElementById('<%= ddlCategory.ClientID %>').value;
    if (!category) {
        errorMessage += '• Please select a category\n';
        isValid = false;
    }

  

    // Check title
    const title = document.getElementById('<%= txtTitle.ClientID %>').value.trim();
    if (!title) {
        errorMessage += '• Please enter item title\n';
        isValid = false;
    }

    // Check description
    const description = document.getElementById('<%= txtDescription.ClientID %>').value.trim();
    if (!description) {
        errorMessage += '• Please enter item description\n';
        isValid = false;
    }

    // Check condition
    const condition = document.getElementById('<%= ddlCondition.ClientID %>').value;
    if (!condition) {
        errorMessage += '• Please select item condition\n';
        isValid = false;
    }

    // Check listing type
    const listingType = document.getElementById('<%= hfListingType.ClientID %>').value;
    if (!listingType) {
        errorMessage += '• Please select listing type (Sell/Exchange/Both)\n';
        isValid = false;
    }

    // Check price for Sell or Both
    if (listingType === 'Sell' || listingType === 'Both') {
        const price = document.getElementById('<%= txtPrice.ClientID %>').value.trim();
        if (!price || parseFloat(price) <= 0) {
            errorMessage += '• Please enter a valid selling price\n';
            isValid = false;
        }
    }

    // Check all 3 images
    const fileInput1 = document.getElementById('<%= fuImage1.ClientID %>');
    const fileInput2 = document.getElementById('<%= fuImage2.ClientID %>');
    const fileInput3 = document.getElementById('<%= fuImage3.ClientID %>');

         if (!fileInput1.files.length || !fileInput2.files.length || !fileInput3.files.length) {
             errorMessage += '• Please upload all 3 product images\n';
             isValid = false;
         }

         if (!isValid) {
             alert('⚠️ Please fix the following errors:\n\n' + errorMessage);
             return false;
         }

         return true;
     }

     // Progress bar update
     function updateProgress() {
         const fields = [
             document.getElementById('<%= ddlCategory.ClientID %>').value,
     
        document.getElementById('<%= txtTitle.ClientID %>').value,
        document.getElementById('<%= txtDescription.ClientID %>').value,
        document.getElementById('<%= ddlCondition.ClientID %>').value,
        document.getElementById('<%= hfListingType.ClientID %>').value,
        document.getElementById('<%= fuImage1.ClientID %>').files.length > 0 ? 'yes' : '',
        document.getElementById('<%= fuImage2.ClientID %>').files.length > 0 ? 'yes' : '',
        document.getElementById('<%= fuImage3.ClientID %>').files.length > 0 ? 'yes' : ''
         ];

         const filledFields = fields.filter(f => f && f.trim() !== '').length;
         const progress = (filledFields / fields.length) * 100;

         document.getElementById('progressFill').style.width = progress + '%';
     }

     // Initialize on page load
     window.onload = function () {
         const inputs = document.querySelectorAll('.form-control');
         inputs.forEach(input => {
             input.addEventListener('change', updateProgress);
             input.addEventListener('input', updateProgress);
         });

         updateProgress();
     };
 </script>
    </asp:Content>