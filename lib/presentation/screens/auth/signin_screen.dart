//lib/presentation/screens/SignIn_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../data/model/Signin_request.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/oauth_button.dart';
import '../../widgets/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_formKey.currentState!.validate()) {
      final signInRequest = SignInRequest(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );

      context.read<AuthBloc>().add(
        SignInRequested(signInRequest: signInRequest),
      );
    }
  }

  void _handleOAuthSignIn(OAuthProvider provider) {
    context.read<AuthBloc>().add(OAuthSignInRequested(provider: provider));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to home screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sign up successful!')),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getHorizontalPadding(context),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    maxWidth: ResponsiveHelper.isDesktop(context)
                        ? 400
                        : double.infinity,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          _buildSocialLoginSection(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          _buildDivider(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          _buildFormFields(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              20,
                            ),
                          ),
                          _buildCreateAccountButton(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              24,
                            ),
                          ),
                          _buildSignUpLink(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.signIn, style: AppStyles.heading(context)),
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
        Text(AppStrings.signInDescription, style: AppStyles.bodyText(context)),
      ],
    );
  }

  Widget _buildSocialLoginSection(BuildContext context) {
    if (ResponsiveHelper.getResponsiveWidth(context) < 350) {
      return Column(
        children: [
          OAuthButton(
            icon: Icons.apple,
            label: AppStrings.appleId,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.apple),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          OAuthButton(
            icon: Icons.g_mobiledata,
            label: AppStrings.google,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.google),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
          OAuthButton(
            icon: Icons.facebook,
            label: AppStrings.facebook,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.facebook),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OAuthButton(
            icon: Icons.apple,
            label: AppStrings.appleId,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.apple),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Icons.g_mobiledata,
            label: AppStrings.google,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.google),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Icons.facebook,
            label: AppStrings.facebook,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.facebook),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.dividerColor, thickness: 2),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsiveSpacing(context, 16),
          ),
          child: Text(
            AppStrings.or,
            style: TextStyle(
              color: const Color(0xFF262626),
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.dividerColor, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          hintText: AppStrings.emailOrPhone,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        CustomTextField(
          controller: _passwordController,
          hintText: AppStrings.password,
          obscureText: _obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.iconColor,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return PrimaryButton(
          text: AppStrings.createAccount,
          onPressed: _handleSignIn,
          isLoading: state is AuthLoading,
        );
      },
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Navigate to sign up screen
          Navigator.of(context).pushReplacementNamed('/signup');
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontFamily: 'Lexend',
              height: 1.57,
            ),
            children: [
              const TextSpan(
                text: AppStrings.haveAccount,
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: AppStrings.signIn,
                style: AppStyles.linkText(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
