<%@ Page Title="About Us - StudySwap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="StudySwap.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Hero Section */
        .about-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 100px 0 80px;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .about-hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="rgba(255,255,255,0.1)" d="M0,96L48,112C96,128,192,160,288,160C384,160,480,128,576,122.7C672,117,768,139,864,144C960,149,1056,139,1152,122.7C1248,107,1344,85,1392,74.7L1440,64L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>') no-repeat bottom;
            background-size: cover;
            opacity: 0.3;
        }
        
        .about-hero h1 {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 20px;
            animation: fadeInUp 0.8s ease;
        }
        
        .about-hero p {
            font-size: 1.3rem;
            opacity: 0.95;
            max-width: 700px;
            margin: 0 auto;
            animation: fadeInUp 0.8s ease 0.2s both;
        }

        /* Mission Section */
        .mission-section {
            padding: 80px 0;
            background: linear-gradient(to bottom, #f8f9fa, white);
        }
        
        .mission-card {
            background: white;
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .mission-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 60px rgba(0,0,0,0.12);
        }
        
        .mission-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }
        
        .mission-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 30px;
            font-size: 2.5rem;
        }

        /* Stats Counter */
        .stats-section {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 80px 0;
            color: white;
            position: relative;
        }
        
        .stat-card {
            text-align: center;
            padding: 30px;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: scale(1.1);
        }
        
        .stat-number {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 10px;
            background: linear-gradient(45deg, #fff, #a8d8ea);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .stat-label {
            font-size: 1.1rem;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Values Section */
        .values-section {
            padding: 80px 0;
            background: white;
        }
        
        .value-card {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            border-radius: 15px;
            padding: 40px 30px;
            margin-bottom: 30px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .value-card:hover {
            transform: translateY(-5px);
            border-color: #667eea;
            background: white;
            box-shadow: 0 15px 35px rgba(102, 126, 234, 0.2);
        }
        
        .value-icon {
            font-size: 3rem;
            margin-bottom: 20px;
        }
        
        .value-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 15px;
            color: #2d3748;
        }

        /* Team Section */
        .team-section {
            padding: 80px 0;
            background: linear-gradient(to bottom, #f8f9fa, white);
        }
        
        .team-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            margin-bottom: 30px;
        }
        
        .team-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }
        
        .team-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: white;
            border: 5px solid #f8f9fa;
        }

        /* Impact Section */
        .impact-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }
        
        .impact-item {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }
        
        .impact-item:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateX(10px);
        }
        
        .impact-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }

        /* CTA Section */
        .cta-section {
            padding: 80px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-align: center;
        }
        
        .cta-button {
            background: white;
            color: #667eea;
            padding: 18px 50px;
            border-radius: 50px;
            font-size: 1.2rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
            color: #764ba2;
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .fade-in {
            animation: fadeInUp 0.8s ease;
        }

        /* Section Headers */
        .section-header {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .section-title {
            font-size: 2.8rem;
            font-weight: 800;
            margin-bottom: 15px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .section-subtitle {
            font-size: 1.2rem;
            color: #718096;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .about-hero h1 {
                font-size: 2.5rem;
            }
            
            .stat-number {
                font-size: 2.5rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Hero Section -->
    <section class="about-hero">
        <div class="container text-center position-relative">
            <h1>Empowering Students, Protecting Our Planet</h1>
            <p>StudySwap is more than a marketplace—it's a movement toward affordable education and sustainable living.</p>
        </div>
    </section>

    <!-- Mission Section -->
    <section class="mission-section">
        <div class="container">
            <div class="row">
                <div class="col-lg-6 mb-4">
                    <div class="mission-card">
                        <div class="mission-icon">🎯</div>
                        <h2 class="mb-4">Our Mission</h2>
                        <p class="lead">To create a trusted, campus-verified ecosystem where students can affordably access academic resources while making a measurable positive impact on the environment.</p>
                        <p class="mt-3">We believe every textbook reused, every calculator passed forward, and every lab kit shared contributes to a more sustainable and equitable educational experience.</p>
                    </div>
                </div>
                <div class="col-lg-6 mb-4">
                    <div class="mission-card">
                        <div class="mission-icon">🌱</div>
                        <h2 class="mb-4">Our Vision</h2>
                        <p class="lead">To become the leading sustainable academic marketplace across educational institutions, fostering a culture of sharing, reuse, and environmental responsibility.</p>
                        <p class="mt-3">We envision a future where no student faces financial barriers to education and where campus communities actively participate in the circular economy.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-number">10K+</div>
                        <div class="stat-label">Verified Students</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-number">25K+</div>
                        <div class="stat-label">Items Exchanged</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-number">₹50L+</div>
                        <div class="stat-label">Student Savings</div>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="stat-card">
                        <div class="stat-number">15T+</div>
                        <div class="stat-label">CO₂ Saved</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Values Section -->
    <section class="values-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Our Core Values</h2>
                <p class="section-subtitle">The principles that guide everything we do</p>
            </div>
            <div class="row">
                <div class="col-md-4">
                    <div class="value-card">
                        <div class="value-icon">🔒</div>
                        <h3 class="value-title">Trust & Safety</h3>
                        <p>Campus verification ensures every user is a genuine student, creating a secure and accountable community.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-card">
                        <div class="value-icon">♻️</div>
                        <h3 class="value-title">Sustainability</h3>
                        <p>Every transaction reduces waste and carbon emissions, making education more environmentally responsible.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-card">
                        <div class="value-icon">💰</div>
                        <h3 class="value-title">Affordability</h3>
                        <p>Students save 50-70% on academic materials, making quality education accessible to everyone.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-card">
                        <div class="value-icon">🤝</div>
                        <h3 class="value-title">Community</h3>
                        <p>Building connections between students, seniors, and juniors through shared academic resources.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-card">
                        <div class="value-icon">⚡</div>
                        <h3 class="value-title">Simplicity</h3>
                        <p>An intuitive platform that makes listing, browsing, and trading academic items effortless.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="value-card">
                        <div class="value-icon">🌟</div>
                        <h3 class="value-title">Transparency</h3>
                        <p>Clear ratings, verified reviews, and honest impact metrics build trust in every transaction.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Impact Section -->
    <section class="impact-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title text-white">Environmental Impact</h2>
                <p class="section-subtitle text-white opacity-75">How StudySwap is making a real difference</p>
            </div>
            <div class="row">
                <div class="col-lg-6">
                    <div class="impact-item">
                        <div class="impact-icon">📚</div>
                        <h4 class="fw-bold mb-3">Paper Waste Reduction</h4>
                        <p>Each reused textbook saves approximately 24 trees from being cut down and prevents 2.5 kg of CO₂ emissions from production.</p>
                    </div>
                    <div class="impact-item">
                        <div class="impact-icon">🔋</div>
                        <h4 class="fw-bold mb-3">E-Waste Prevention</h4>
                        <p>Every calculator and electronic device reused prevents toxic e-waste from entering landfills and conserves precious raw materials.</p>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="impact-item">
                        <div class="impact-icon">🌍</div>
                        <h4 class="fw-bold mb-3">Carbon Footprint</h4>
                        <p>By extending product lifecycles, we've collectively prevented over 15 tonnes of CO₂ emissions equivalent to planting 700+ trees.</p>
                    </div>
                    <div class="impact-item">
                        <div class="impact-icon">💧</div>
                        <h4 class="fw-bold mb-3">Resource Conservation</h4>
                        <p>Reusing lab equipment and study materials saves water, energy, and raw materials used in manufacturing new products.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Team Section -->
    <section class="team-section">
        <div class="container">
            <div class="section-header">
                <h2 class="section-title">Built by Students, For Students</h2>
                <p class="section-subtitle">A passionate team committed to sustainable education</p>
            </div>
            <div class="row justify-content-center">
                <div class="col-md-3 col-sm-6">
                    <div class="team-card">
                        <div class="team-avatar">👨‍💻</div>
                        <h4 class="fw-bold">Development Team</h4>
                        <p class="text-muted">Building the platform with cutting-edge technology</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="team-card">
                        <div class="team-avatar">🎨</div>
                        <h4 class="fw-bold">Design Team</h4>
                        <p class="text-muted">Creating intuitive user experiences</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="team-card">
                        <div class="team-avatar">🌱</div>
                        <h4 class="fw-bold">Sustainability Team</h4>
                        <p class="text-muted">Tracking and maximizing environmental impact</p>
                    </div>
                </div>
                <div class="col-md-3 col-sm-6">
                    <div class="team-card">
                        <div class="team-avatar">🤝</div>
                        <h4 class="fw-bold">Community Team</h4>
                        <p class="text-muted">Supporting students and building connections</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <h2 class="display-4 fw-bold mb-4">Join the Movement</h2>
            <p class="lead mb-5">Start saving money and protecting the planet today</p>
            <a href="Register.aspx" class="cta-button">Register Now</a>
            <a href="Default.aspx" class="cta-button ms-3" style="background: transparent; color: white; border: 2px solid white;">Learn More</a>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <script>
        // Counter animation
        document.addEventListener('DOMContentLoaded', function() {
            const counters = document.querySelectorAll('.stat-number');
            const speed = 200;
            
            const observerOptions = {
                threshold: 0.5
            };
            
            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const counter = entry.target;
                        const updateCount = () => {
                            const target = counter.textContent.replace(/[^0-9]/g, '');
                            const count = +counter.getAttribute('data-count') || 0;
                            const inc = Math.ceil(target / speed);
                            
                            if (count < target) {
                                counter.setAttribute('data-count', count + inc);
                                const suffix = counter.textContent.match(/[^0-9]+$/)?.[0] || '';
                                counter.textContent = (count + inc) + suffix;
                                setTimeout(updateCount, 1);
                            } else {
                                const suffix = counter.textContent.match(/[^0-9]+$/)?.[0] || '';
                                counter.textContent = target + suffix;
                            }
                        };
                        updateCount();
                        observer.unobserve(counter);
                    }
                });
            }, observerOptions);
            
            counters.forEach(counter => observer.observe(counter));
        });
    </script>
</asp:Content>