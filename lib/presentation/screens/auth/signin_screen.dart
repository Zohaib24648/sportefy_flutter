//lib/presentation/screens/SignIn_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportefy/presentation/widgets/constants/or_divider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../../bloc/auth/auth_bloc.dart';
import '../../../data/model/signin_request.dart';
import '../../constants/app_strings.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../utils/responsive_helper.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/oauth_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/clickable_text.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _rememberMe = true;
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
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthError) {
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
                    maxWidth: double.infinity,
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
                          OrDivider(),
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
                          _buildSignInButton(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              16,
                            ),
                          ),
                          _buildSignUpLink(context),
                          SizedBox(
                            height: ResponsiveHelper.getResponsiveSpacing(
                              context,
                              8,
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
        SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 8)),
        Text(AppStrings.signInDescription, style: AppStyles.bodyText(context)),
      ],
    );
  }

  Widget _buildSocialLoginSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OAuthButton(
            icon: Image.asset('assets/logos/apple.png', width: 24, height: 24),
            label: AppStrings.appleId,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.apple),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Image.asset('assets/logos/google.png', width: 24, height: 24),
            label: AppStrings.google,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.google),
          ),
        ),
        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 10)),
        Expanded(
          child: OAuthButton(
            icon: Image.asset(
              'assets/logos/facebook.png',
              width: 24,
              height: 24,
            ),
            label: AppStrings.facebook,
            onPressed: () => _handleOAuthSignIn(OAuthProvider.facebook),
          ),
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

  Widget _buildSignInButton(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return PrimaryButton(
          text: AppStrings.signIn,
          onPressed: _handleSignIn,
          isLoading: state is AuthLoading,
        );
      },
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.haveAccount,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              fontFamily: 'Lexend',
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
          ),
          ClickableText(
            text: AppStrings.signUp,
            routeName: '/signup',
            color: AppColors.primaryColor,
            fontSize: 14,
            isBold: false,
          ),
        ],
      ),
    );
  }
}
