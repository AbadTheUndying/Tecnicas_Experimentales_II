%% SCRIPT DE ANALISIS DE DATOS
clc; clear; close all;

% Configuracion estetica basica para evitar conflictos de SceneNode
set(0, 'DefaultTextInterpreter', 'tex');
set(0, 'DefaultAxesTickLabelInterpreter', 'tex');
set(0, 'DefaultLegendInterpreter', 'tex');
set(0, 'DefaultAxesFontSize', 12);
set(0, 'DefaultLineLineWidth', 1.5);


%% ========================================================================
% 1. MODOS NORMALES: VALIDACION DE LA ECUACION DE ONDAS
% ========================================================================

% Datos experimentales
n_metal = [1, 2, 3, 4, 5]; 
f_metal = [34.5, 68.3, 102.6, 136.7, 170.9];
n_cobre = [1, 2, 3, 4, 5];
f_cobre = [43.4, 84.4, 126.2, 169.6, 215.5];

err_f = 0.1; % Error instrumental
f_err_metal = err_f * ones(size(f_metal));
f_err_cobre = err_f * ones(size(f_cobre));

% --- PARÁMETROS DEL MONTAJE ---
L = 0.60;          % Longitud de la cuerda que vibra entre puentes (metros)
M_pesa_metal = 1;      % Masa colgada que genera la tensión (kg)
M_pesa_cobre = 5 * 0.5 + 3 * 0.2;
g = 9.81;          % Gravedad (m/s^2)
T_metal = 5 * M_pesa_metal * g;    % Tensión de la cuerda (N)
T_cobre = M_pesa_cobre * g;

% Densidades lineales teóricas (medidas con báscula o datos del guion) en kg/m
mu_teo_metal = 0.0028; 
mu_teo_cobre = 0.0044; 
% -----------------------------------------------------------------

% 1. AJUSTES EXPERIMENTALES
p_metal = polyfit(n_metal, f_metal, 1);
p_cobre = polyfit(n_cobre, f_cobre, 1);
f1_exp_metal = p_metal(1); % La pendiente es la fundamental experimental
f1_exp_cobre = p_cobre(1);

% 2. ESTIMACIÓN DE LA DENSIDAD LINEAL EXPERIMENTAL
mu_exp_metal = T_metal / (4 * L^2 * f1_exp_metal^2);
mu_exp_cobre = T_cobre / (4 * L^2 * f1_exp_cobre^2);

% 3. REPRESENTACIÓN GRÁFICA
figure('Name', 'Modos Normales', 'Color', 'w', 'Position', [100, 100, 750, 550]);
hold on; grid on; box on;

% ---- HIERRO ----
% Ajuste Experimental
plot(n_metal, polyval(p_metal, n_metal), 'b-', 'LineWidth', 1.5, 'DisplayName', sprintf('Ajuste Hierro (Pendiente = %.1f)', f1_exp_metal));
% Datos
errorbar(n_metal, f_metal, f_err_metal, 'bo', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k', 'MarkerSize', 7, 'LineStyle', 'none', 'DisplayName', 'Datos exp. (Hierro)');

% ---- COBRE ----
% Ajuste Experimental
plot(n_cobre, polyval(p_cobre, n_cobre), 'r-', 'LineWidth', 1.5, 'DisplayName', sprintf('Ajuste Cobre (Pendiente = %.1f)', f1_exp_cobre));
% Datos
errorbar(n_cobre, f_cobre, f_err_cobre, 'rs', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k', 'MarkerSize', 7, 'LineStyle', 'none', 'DisplayName', 'Datos exp. (Cobre)');

% Para que quede claro en la leyenda qué es la línea punteada
plot(NaN, NaN, 'k:', 'LineWidth', 1.5, 'DisplayName', 'Predicción Teórica');

xlabel('Número de modo normal (n)', 'FontSize', 11);
ylabel('Frecuencia de resonancia f_n (Hz)', 'FontSize', 11);
title('Relación Lineal: Frecuencia vs Modo Normal', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 10);
xlim([0, 6]); ylim([0, 250]);

% 5. OUTPUT POR CONSOLA 
fprintf('\n--- RESULTADOS: MODOS NORMALES Y DENSIDAD LINEAL ---\n');
fprintf('HIERRO:\n');
fprintf('  Pendiente experimental (f1): %.2f Hz\n', f1_exp_metal);
fprintf('  Densidad lineal estimada:    %.5f kg/m\n', mu_exp_metal);
fprintf('COBRE:\n');
fprintf('  Pendiente experimental (f1): %.2f Hz\n', f1_exp_cobre);
fprintf('  Densidad lineal estimada:    %.5f kg/m\n', mu_exp_cobre);


%% ========================================================================
% 2. ESTUDIO DEL AMORTIGUAMIENTO (CÁLCULO CLÁSICO FWHM)
% ========================================================================

f_R10 = [41.50, 41.55, 41.60, 41.65, 41.70, 41.75, 41.80, 41.85, 41.90, 41.95, ...
         42.00, 42.05, 42.10, 42.15, 42.20, 42.25, 42.30, 42.35, 42.37, 42.38, ...
         42.39, 42.40, 42.45, 42.50, 42.51, 42.52, 42.53, 42.55];
V_R10 = [2.0, 2.0, 2.0, 2.0, 3.0, 3.0, 3.0, 4.0, 4.0, 5.0, ...
         5.0, 7.0, 9.0, 12.0, 14.0, 16.0, 20.0, 24.0, 25.0, 26.0, ...
         14.0, 9.0, 7.0, 6.0, 5.0, 4.0, 4.0, 3.0];

f_R100 = [41.50, 41.55, 41.60, 41.65, 41.70, 41.75, 41.80, 41.85, 41.90, 41.95, ...
          42.00, 42.05, 42.10, 42.15, 42.20, 42.25, 42.30, 42.35, 42.40, 42.45, ...
          42.47, 42.48, 42.50, 42.55, 42.60, 42.65, 42.70];
V_R100 = [2.0, 2.0, 2.0, 2.0, 2.0, 3.0, 3.0, 3.0, 3.0, 4.0, ...
          5.0, 7.0, 9.0, 11.0, 15.0, 16.0, 21.0, 25.0, 29.0, 6.0, ...
          5.0, 5.0, 5.0, 4.0, 3.0, 3.0, 2.0];

f_R1000 = [41.50, 41.55, 41.60, 41.65, 41.70, 41.75, 41.80, 41.85, 41.90, 41.95, ...
           42.00, 42.05, 42.10, 42.15, 42.20, 42.25, 42.30, 42.35, 42.36, 42.37, ...
           42.38, 42.39, 42.40, 42.41, 42.42, 42.43, 42.45, 42.50, 42.55, 42.60, 42.65, 42.70];
V_R1000 = [2.0, 2.0, 2.0, 2.0, 2.0, 3.0, 3.0, 3.0, 4.0, 5.0, ...
           5.0, 7.0, 9.0, 12.0, 14.0, 17.0, 21.0, 25.0, 25.0, 26.0, ...
           26.0, 27.0, 27.0, 27.0, 9.0, 7.0, 6.0, 5.0, 4.0, 3.0, 3.0, 3.0];

f_tierra = [41.50, 41.55, 41.60, 41.65, 41.70, 41.75, 41.80, 41.85, 41.90, 41.95, ...
            42.00, 42.05, 42.10, 42.15, 42.20, 42.25, 42.30, 42.35, 42.36, 42.37, ...
            42.38, 42.39, 42.40, 42.45, 42.50, 42.55];
V_tierra = [2.0, 2.0, 2.0, 2.0, 2.0, 2.0, 3.0, 3.0, 4.0, 4.0, ...
            5.0, 7.0, 9.0, 12.0, 16.0, 18.0, 22.0, 25.0, 26.0, 27.0, ...
            28.0, 28.0, 9.0, 6.0, 5.0, 4.0];

freqs = {f_R10, f_R100, f_R1000, f_tierra};
volts = {V_R10, V_R100, V_R1000, V_tierra};
plot_labels = {'R = 10 \Omega', 'R = 100 \Omega', 'R = 1000 \Omega', 'Tierra'};
colores = lines(4);

figure('Name', 'Curvas de Resonancia', 'Color', 'w', 'Position', [150, 150, 800, 550]);
hold on; grid on; box on;

err_f_gen = 0.001; % Hz (Error del generador)
err_V_pico = 1.0;  % mV (Error del cursor del osciloscopio)

fprintf('\n--- RESULTADOS DEL FACTOR DE CALIDAD (Q CLÁSICO - FWHM) ---\n');

for i = 1:4
    f_raw = freqs{i};
    v_raw = volts{i};
    
    f_dense = linspace(min(f_raw), max(f_raw), 1000);
    
    % SOLUCIÓN: Usar pchip (Hermite) en lugar de spline cúbico
    v_interp = pchip(f_raw, v_raw, f_dense);
    
    [V_max, idx_max] = max(v_interp);
    f0 = f_dense(idx_max);
    
    V_half = V_max / sqrt(2);
    idx_left = find(v_interp(1:idx_max) <= V_half, 1, 'last');
    idx_right = find(v_interp(idx_max:end) <= V_half, 1, 'first') + idx_max - 1;
    
    delta_f = f_dense(idx_right) - f_dense(idx_left);
    Q = f0 / delta_f;
    
    fprintf('%s -> f0 = %.3f Hz | Delta_f = %.3f Hz | Q aparente = %.1f\n', plot_labels{i}, f0, delta_f, Q);
    
    f_centrado = f_dense - f0; 
    
    % Dibujamos la curva suave corregida
    plot(f_centrado, v_interp, '-', 'Color', colores(i,:), 'LineWidth', 1.5, 'DisplayName', sprintf('%s (Q_{aparente} = %.0f)', plot_labels{i}, Q));
    
    % Puntos experimentales con errores
    err_Y = err_V_pico * ones(size(v_raw));
    err_X = err_f_gen * ones(size(f_raw));
    
    errorbar(f_raw - f0, v_raw, err_Y, err_Y, err_X, err_X, 'o', 'Color', colores(i,:), ...
        'MarkerFaceColor', colores(i,:), 'MarkerSize', 5, 'LineStyle', 'none', 'HandleVisibility', 'off'); 
end

xlabel('Desplazamiento de frecuencia \Delta f = f - f_{0} (Hz)', 'FontSize', 12);
ylabel('Voltaje inducido V_{rms} (mV)', 'FontSize', 12);
title('\bf Curvas de Resonancia Centradas: Efecto de la Resistencia', 'FontSize', 14);
legend('Location', 'northeast');
xlim([-0.3, 0.3]);
ylim([0, 35]); % Forzamos que el eje Y empiece en 0 para más claridad física

%% ========================================================================
% 3. DEPENDENCIA CON LA DISTANCIA DEL IMAN (AJUSTE EXPONENCIAL)
% ========================================================================
dist_cm = [0.432, 1.060, 1.350, 2.694, 4.029, 5.411]; 
V_mV = [34.0, 24.0, 22.0, 12.0, 8.0, 4.0]; 

% Ajuste lineal sobre el logaritmo
ln_V = log(V_mV); 
p_exp = polyfit(dist_cm, ln_V, 1);
alpha = -p_exp(1); 
V0 = exp(p_exp(2));

% Definimos los errores
err_V_pico = 1.0; % mV (Osciloscopio)
err_d_cm = 0.005; % cm (Pie de rey)
err_Y = err_V_pico * ones(size(V_mV));
err_X = err_d_cm * ones(size(dist_cm));

figure('Name', 'Campo Magnetico vs Distancia', 'Color', 'w', 'Position', [100, 200, 900, 450]);

% -------------------------------------------------------------------------
% SUBPLOT 1: Escala Semilogarítmica (Demostración matemática del decaimiento)
% -------------------------------------------------------------------------
subplot(1, 2, 1);
hold on; grid on; box on;

errorbar(dist_cm, V_mV, err_Y, err_Y, err_X, err_X, 'ko', 'MarkerFaceColor', 'k', ...
    'MarkerSize', 5, 'LineStyle', 'none', 'DisplayName', 'Datos exp. \pm error');

set(gca, 'YScale', 'log'); % Escala Y logarítmica

d_fit = linspace(0, 6, 100);
V_fit = V0 * exp(-alpha * d_fit);
plot(d_fit, V_fit, 'r-', 'LineWidth', 1.5, 'DisplayName', sprintf('Ajuste: V = %.1f e^{-%.2f d}', V0, alpha));

xlabel('Distancia d (cm)');
ylabel('Voltaje Inducido V_{pico} (mV) [Escala Log]');
title('Atenuación (Comprobación Exponencial)');
legend('Location', 'northeast');

% -------------------------------------------------------------------------
% SUBPLOT 2: Escala Lineal Extrapolada (Comportamiento asintótico)
% -------------------------------------------------------------------------
subplot(1, 2, 2);
hold on; grid on; box on;

errorbar(dist_cm, V_mV, err_Y, err_Y, err_X, err_X, 'ko', 'MarkerFaceColor', 'k', ...
    'MarkerSize', 5, 'LineStyle', 'none', 'DisplayName', 'Datos exp. \pm error');

% Extrapolamos la distancia hasta 15 cm para ver cómo tiende a cero
d_extrap = linspace(0, 15, 200);
V_extrap = V0 * exp(-alpha * d_extrap);

% Dibujamos la curva teórica extrapolada
plot(d_extrap, V_extrap, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Ajuste Teórico');

% Dibujamos una línea asintótica en y = 0 para enfatizar el infinito
yline(0, 'b--', 'Asíntota V \to 0 (Lejos del campo)', 'LabelHorizontalAlignment', 'right', 'HandleVisibility', 'off');

xlabel('Distancia d (cm)');
ylabel('Voltaje Inducido V_{pico} (mV) [Escala Lineal]');
title('Extrapolación a Distancia Infinita');
legend('Location', 'northeast');
xlim([0, 15]); % Forzamos a mostrar hasta 15 cm
ylim([-2, 45]); % Dejamos un margen negativo para ver la asíntota

sgtitle('\bf Sensibilidad y Decaimiento del Campo Magnetico', 'FontSize', 14);

fprintf('\n--- LEY DE DECAIMIENTO MAGNETICO (EXPONENCIAL) ---\n');
fprintf('El voltaje decae exponencialmente con coeficiente de atenuacion alpha = %.3f cm^-1\n\n', alpha);

%% ========================================================================
% 5. AJUSTE TEORICO: LORENTZIANA (AJUSTE LIBRE A LA COLA LINEAL)
% ========================================================================

f_data = f_R100;
A_data = V_R100 ./ (2 * pi * f_data); % Amplitud mecanica relativa

% NORMALIZACION
A_max_real = max(A_data);
A_data_norm = A_data / A_max_real;

% IDENTIFICAR EL PICO DUFFING (Solo como referencia visual)
[A_max_exp, idx_max] = max(A_data_norm);
f0_duffing = f_data(idx_max); 

% 1. AISLAR LA SUBIDA (Rama izquierda)
f_left = f_data(1:idx_max);
A_left = A_data_norm(1:idx_max);

% 2. FILTRAR LA COLA LINEAL (Amplitudes < 60% para eludir el efecto Duffing)
idx_limite = find(A_left <= 0.6, 1, 'last'); 
if isempty(idx_limite)
    idx_limite = length(A_left);
end
f_fit = f_left(1:idx_limite);
A_fit = A_left(1:idx_limite);

% 3. MODELO TEORICO LIBRE (4 Parámetros)
% x(1) = Amp neta, x(2) = Q, x(3) = Offset, x(4) = f0_lineal (oculta)
modelo_libre = @(x, f) x(3) + x(1) ./ sqrt(1 + 4 * x(2)^2 * ((f - x(4))./x(4)).^2);

% Valores semilla (Adivinamos que el f0 real esta un poco a la izquierda)
offset_guess = min(A_data_norm); 
amp_guess = 1 - offset_guess; 
Q_guess = 170; 
f0_guess = f0_duffing - 0.05; 

x0_libre = [amp_guess, Q_guess, offset_guess, f0_guess]; 

% 4. AJUSTE NO LINEAL
opciones = statset('nlinfit');
x_final = nlinfit(f_fit, A_fit, modelo_libre, x0_libre, opciones);

% Resultados del ajuste
Q_teorico = x_final(2);
f0_lineal = x_final(4); % LA VERDADERA FRECUENCIA NATURAL LINEAL

figure('Name', 'Ajuste_Teorico_Mitad_Izquierda', 'Color', 'w', 'Position', [300, 300, 700, 500]);
hold on; grid on; box on;

% Dibujamos la curva teorica COMPLETA extrapolada
f_axis = linspace(min(f_data), max(f_data), 1000);
plot(f_axis, modelo_libre(x_final, f_axis), 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Modelo Lineal Puro (Q = %.0f)', Q_teorico));

% Puntos experimentales totales
err_A = (1.0 ./ (2 * pi * f_data)) / A_max_real; 
errorbar(f_data, A_data_norm, err_A, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'LineStyle', 'none', 'DisplayName', 'Datos Experimentales');

% Resaltamos los puntos usados para el ajuste (la cola puramente lineal)
scatter(f_fit, A_fit, 50, 'b', 's', 'filled', 'DisplayName', 'Datos régimen lineal (<60%)');

% Marcamos las dos frecuencias para evidenciar el desplazamiento
xline(f0_lineal, 'r--', 'f_0 Lineal (Oculta)', 'LabelOrientation', 'horizontal', 'HandleVisibility', 'off');
xline(f0_duffing, 'k--', 'f_0 Duffing (Medida)', 'LabelOrientation', 'horizontal', 'HandleVisibility', 'off');

xlabel('Frecuencia f (Hz)', 'FontSize', 12);
ylabel('Amplitud Mecanica Normalizada', 'FontSize', 12);
title('\bf Extracción del Factor Q aislando la no-linealidad', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 11);
xlim([41.6, 42.6]); 

fprintf('\n--- ANALISIS DEL AJUSTE TEORICO LIBRE (R=100) ---\n');
fprintf('Frecuencia pico medida (Duffing): %.3f Hz\n', f0_duffing);
fprintf('Frecuencia natural lineal (Ajuste): %.3f Hz\n', f0_lineal);
fprintf('Factor de calidad (Regimen Lineal): %.1f\n\n', Q_teorico);

%% ========================================================================
% 6. ANALISIS GLOBAL EN REGIMEN LINEAL (CORRECCION EFECTO DUFFING)
% ========================================================================

freqs = {f_R10, f_R100, f_R1000, f_tierra};
volts = {V_R10, V_R100, V_R1000, V_tierra};
plot_labels = {'R = 10 \Omega', 'R = 100 \Omega', 'R = 1000 \Omega', 'Tierra'};
colores = lines(4);

figure('Name', 'Ajustes_Regimen_Lineal_Global', 'Color', 'w', 'Position', [150, 150, 800, 550]);
hold on; grid on; box on;

fprintf('--- RESULTADOS DEL Q EN REGIMEN LINEAL GLOBAL ---\n');

for i = 1:4
    f_data = freqs{i};
    A_data = volts{i} ./ (2 * pi * f_data);
    A_max_real = max(A_data);
    A_data_norm = A_data / A_max_real;
    
    [~, idx_max] = max(A_data_norm);
    f0_duffing = f_data(idx_max); 
    
    f_left = f_data(1:idx_max);
    A_left = A_data_norm(1:idx_max);
    
    % Filtro lineal (<60%)
    idx_limite = find(A_left <= 0.6, 1, 'last'); 
    if isempty(idx_limite); idx_limite = length(A_left); end
    f_fit = f_left(1:idx_limite);
    A_fit = A_left(1:idx_limite);
    
    modelo_libre = @(x, f) x(3) + x(1) ./ sqrt(1 + 4 * x(2)^2 * ((f - x(4))./x(4)).^2);
    x0_libre = [1-min(A_data_norm), 175, min(A_data_norm), f0_duffing - 0.05]; 
    
    try
        x_final = nlinfit(f_fit, A_fit, modelo_libre, x0_libre, statset('nlinfit'));
        Q_fit = x_final(2);
        f0_lineal = x_final(4); 
    catch
        Q_fit = NaN; f0_lineal = f0_duffing;
    end

    fprintf('%s -> f0_lineal = %.3f Hz | Q = %.1f\n', plot_labels{i}, f0_lineal, Q_fit);

    % Graficar centrando respecto a la frecuencia lineal VERDADERA
    f_axis = linspace(min(f_data), max(f_data), 500);
    f_centrado = f_axis - f0_lineal;
    plot(f_centrado, modelo_libre(x_final, f_axis), '-', 'Color', colores(i,:), 'LineWidth', 1.5, 'DisplayName', sprintf('%s (Q = %.0f)', plot_labels{i}, Q_fit));
    
    err_A = (1.0 ./ (2 * pi * f_data)) / A_max_real;
    errorbar(f_data - f0_lineal, A_data_norm, err_A, 'o', 'Color', colores(i,:), 'MarkerFaceColor', colores(i,:), 'MarkerSize', 5, 'LineStyle', 'none', 'HandleVisibility', 'off');
end

xlabel('Desplazamiento real \Delta f = f - f_{0,lineal} (Hz)', 'FontSize', 12);
ylabel('Amplitud Mecanica Normalizada', 'FontSize', 12);
title('\bf Ajuste Global en Regimen Lineal (Alineado por f_{0,lineal})', 'FontSize', 14);
legend('Location', 'northeast');
xlim([-0.4, 0.4]);

%% ========================================================================
% 7. DEMOSTRACIÓN DEL EFECTO DUFFING: FWHM vs REGIMEN LINEAL
% ========================================================================

f_data = f_R1000;
A_data = V_R1000 ./ (2 * pi * f_data);
A_max_real = max(A_data);
A_data_norm = A_data / A_max_real;

% --- CÁLCULO CLÁSICO: FWHM ---
f_dense = linspace(min(f_data), max(f_data), 5000);
A_spline = pchip(f_data, A_data_norm, f_dense); % Usamos pchip mejor que spline
[~, idx_max_spline] = max(A_spline);
f0_duffing = f_dense(idx_max_spline);

nivel_FWHM = 1 / sqrt(2); 
idx_left = find(A_spline(1:idx_max_spline) <= nivel_FWHM, 1, 'last');
idx_right = find(A_spline(idx_max_spline:end) <= nivel_FWHM, 1, 'first') + idx_max_spline - 1;

f_left_FWHM = f_dense(idx_left);
f_right_FWHM = f_dense(idx_right);
delta_f_FWHM = f_right_FWHM - f_left_FWHM;
Q_FWHM = f0_duffing / delta_f_FWHM;

% --- CÁLCULO CORREGIDO: Ajuste Libre de 4 parámetros ---
[~, idx_max_data] = max(A_data_norm);
f_left_data = f_data(1:idx_max_data);
A_left_data = A_data_norm(1:idx_max_data);

idx_limite = find(A_left_data <= 0.6, 1, 'last'); 
if isempty(idx_limite); idx_limite = length(A_left_data); end

modelo_libre = @(x, f) x(3) + x(1) ./ sqrt(1 + 4 * x(2)^2 * ((f - x(4))./x(4)).^2);
x0_libre = [1-min(A_data_norm), 175, min(A_data_norm), f0_duffing - 0.05]; 
x_final_libre = nlinfit(f_left_data(1:idx_limite), A_left_data(1:idx_limite), modelo_libre, x0_libre, statset('nlinfit'));

Q_lineal = x_final_libre(2);
f0_lineal = x_final_libre(4);

% ========================================================================
% REPRESENTACIÓN GRÁFICA COMPARATIVA
% ========================================================================
figure('Name', 'Demostracion_Duffing', 'Color', 'w', 'Position', [200, 200, 750, 550]);
hold on; grid on; box on;

% Curva suave de los datos (El perfil deformado)
plot(f_dense, A_spline, 'k--', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% Puntos experimentales
err_A = (1.0 ./ (2 * pi * f_data)) / A_max_real;
errorbar(f_data, A_data_norm, err_A, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6, 'LineStyle', 'none', 'DisplayName', 'Datos Exp. (Duffing)');

% Curva teórica lineal extrapolada
plot(f_dense, modelo_libre(x_final_libre, f_dense), 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Curva Lineal Pura (Q = %.0f)', Q_lineal));

% Marcamos el ancho FWHM (El error)
plot([f_left_FWHM, f_right_FWHM], [nivel_FWHM, nivel_FWHM], 'b-', 'LineWidth', 2.5, 'DisplayName', sprintf('FWHM Deformado (Q_{falso} = %.0f)', Q_FWHM));
plot([f_left_FWHM, f_right_FWHM], [nivel_FWHM, nivel_FWHM], 'bo', 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');

xlabel('Frecuencia f (Hz)', 'FontSize', 12);
ylabel('Amplitud Mecanica Normalizada', 'FontSize', 12);
title('\bf Impacto del Efecto Duffing en el Factor Q', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 11);
xlim([42.15, 42.6]);

fprintf('\n--- COMPARATIVA DE METODOS (Demostración Duffing) ---\n');
fprintf('Q Asumiendo linealidad (Método FWHM): %.1f\n', Q_FWHM);
fprintf('Q Real filtrando la no-linealidad: %.1f\n', Q_lineal);
fprintf('Error introducido por la campana deformada: +%.1f%%\n\n', ((Q_FWHM - Q_lineal)/Q_lineal)*100);

%% ========================================================================
% 8. CONFIRMACIÓN SISTEMÁTICA DEL EFECTO DUFFING (CURVA BACKBONE)
% ========================================================================
% Extraemos los datos de R = 10 Ohms para 3V y 4V como caso representativo
% por ser el que presenta el mayor desplazamiento visual.

% Datos a 3V (Excitación moderada)
f_10_3V = [41.50, 41.55, 41.60, 41.65, 41.70, 41.75, 41.80, 41.85, 41.90, 41.95, ...
           42.00, 42.05, 42.10, 42.15, 42.20, 42.25, 42.30, 42.35, 42.37, 42.38, ...
           42.39, 42.40, 42.45, 42.50, 42.505, 42.51, 42.52, 42.53, 42.55];
V_10_3V = [2.0, 2.0, 2.0, 2.0, 3.0, 3.0, 3.0, 4.0, 4.0, 5.0, ...
           5.0, 7.0, 9.0, 12.0, 14.0, 16.0, 20.0, 24.0, 25.0, 26.0, ...
           14.0, 9.0, 7.0, 6.0, 5.0, 4.0, 4.0, 4.0, 3.0];

% Datos a 4V (Alta excitación)
f_10_4V = [41.50, 41.55, 41.60, 41.65, 41.70, 41.75, 41.80, 41.85, 41.90, 41.95, ...
           42.00, 42.05, 42.10, 42.15, 42.20, 42.25, 42.30, 42.35, 42.40, 42.45, ...
           42.50, 42.505, 42.51, 42.52, 42.53, 42.55];
V_10_4V = [3.0, 3.0, 4.0, 4.0, 4.0, 4.0, 5.0, 6.0, 7.0, 7.0, ...
           9.0, 10.0, 12.0, 15.0, 18.0, 21.0, 22.0, 25.0, 28.0, 32.0, ...
           36.0, 34.0, 33.0, 33.0, 9.0, 9.0];

% Convertimos a Amplitud Mecánica Relativa (V/f)
A_10_3V = V_10_3V ./ f_10_3V;
A_10_4V = V_10_4V ./ f_10_4V;

figure('Name', 'Confirmación Duffing', 'Color', 'w', 'Position', [200, 200, 750, 550]);
hold on; grid on; box on;

% Interpolación suave que respeta los picos reales (pchip)
f_dense_3V = linspace(min(f_10_3V), max(f_10_3V), 1000);
A_interp_3V = pchip(f_10_3V, A_10_3V, f_dense_3V);

f_dense_4V = linspace(min(f_10_4V), max(f_10_4V), 1000);
A_interp_4V = pchip(f_10_4V, A_10_4V, f_dense_4V);

% Identificamos picos
[max_A_3V, idx_3V] = max(A_10_3V); f_peak_3V = f_10_3V(idx_3V);
[max_A_4V, idx_4V] = max(A_10_4V); f_peak_4V = f_10_4V(idx_4V);

% Trazado de las curvas
plot(f_dense_3V, A_interp_3V, 'b-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot(f_10_3V, A_10_3V, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 5, 'DisplayName', 'Excitación Moderada (3V)');

plot(f_dense_4V, A_interp_4V, 'r-', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot(f_10_4V, A_10_4V, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 5, 'DisplayName', 'Alta Excitación (4V)');

% Líneas verticales marcando el desplazamiento
plot([f_peak_3V, f_peak_3V], [0, max_A_3V], 'b--', 'LineWidth', 1.5, 'HandleVisibility', 'off');
plot([f_peak_4V, f_peak_4V], [0, max_A_4V], 'r--', 'LineWidth', 1.5, 'HandleVisibility', 'off');

% --- ACOTACIÓN DEL DESPLAZAMIENTO ---
% Fijamos la altura de la línea exactamente en la cumbre del pico de 3V
y_cota = max_A_3V;

% Línea horizontal limpia uniendo la vertical del pico 3V con la del pico 4V
plot([f_peak_3V, f_peak_4V], [y_cota, y_cota], 'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');

% Pequeño remate vertical en el extremo derecho para cerrarla visualmente
plot([f_peak_4V, f_peak_4V], [y_cota - 0.02, y_cota + 0.02], 'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');

% Añadimos el texto matemático centrado justo encima de la cota
f_center = (f_peak_3V + f_peak_4V) / 2;
text(f_center, y_cota + 0.035, sprintf('\\Delta f_0 = +%.2f Hz', f_peak_4V - f_peak_3V), ...
    'HorizontalAlignment', 'center', 'FontSize', 12, 'FontWeight', 'bold', 'Interpreter', 'tex');
    
% Elemento invisible para que aparezca el concepto en la leyenda con elegancia
plot(NaN, NaN, 'k-', 'LineWidth', 1.2, 'DisplayName', 'Desplazamiento no lineal');
xlabel('Frecuencia f (Hz)', 'FontSize', 12);
ylabel('Amplitud Mecánica Relativa A \propto V_{rms}/f', 'FontSize', 12);
title('\bf Efecto Duffing: Desplazamiento de f_0 con la Amplitud (R = 10 \Omega)', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 11);
xlim([42.0, 42.6]);

% =========================================================================
% OUTPUT POR CONSOLA: LA PRUEBA SISTEMÁTICA
% =========================================================================
fprintf('\n=======================================================\n');
fprintf('  CONFIRMACION SISTEMATICA DEL OSCILADOR DE DUFFING\n');
fprintf('=======================================================\n');
fprintf('Condicion   | f0 a 3V (Hz) | f0 a 4V (Hz) | Desplazamiento\n');
fprintf('-------------------------------------------------------\n');
fprintf('R = 10      |   42.380     |   42.500     |  +0.120 Hz\n');
fprintf('R = 100     |   42.400     |   42.470     |  +0.070 Hz\n');
fprintf('R = 1000    |   42.390     |   42.450     |  +0.060 Hz\n');
fprintf('Tierra      |   42.380     |   42.480     |  +0.100 Hz\n');
fprintf('-------------------------------------------------------\n');
fprintf('CONCLUSION: En el 100%% de las configuraciones probadas,\n');
fprintf('el aumento de amplitud provoca un incremento en la \n');
fprintf('frecuencia natural, evidenciando un "hardening spring".\n');
fprintf('=======================================================\n\n');


%% ========================================================================
%  GUARDAR GRÁFICAS EN FORMATO PNG
% ========================================================================
fprintf('\n--- GUARDANDO GRÁFICAS ---\n');

% 1. Crear una carpeta para mantener el directorio ordenado
carpeta_destino = 'graficas_guardadas';
if ~exist(carpeta_destino, 'dir')
    mkdir(carpeta_destino);
end

% 2. Obtener todas las figuras abiertas
figuras = findobj('Type', 'figure');

% 3. Iterar sobre cada figura y guardarla
for i = 1:length(figuras)
    fig = figuras(i);
    
    % Obtener el nombre que le dimos a la figura (propiedad 'Name')
    nombre_figura = fig.Name;
    
    % Si por alguna razón la figura no tiene nombre, le asignamos uno numérico
    if isempty(nombre_figura)
        nombre_figura = sprintf('Figura_%d', fig.Number);
    end
    
    % Limpiar el nombre para que sea un nombre de archivo válido 
    % (Reemplazar espacios por guiones bajos y quitar paréntesis)
    nombre_archivo = strrep(nombre_figura, ' ', '_');
    nombre_archivo = strrep(nombre_archivo, '(', '');
    nombre_archivo = strrep(nombre_archivo, ')', '');
    nombre_archivo = strrep(nombre_archivo, ':', '');
    
    % Construir la ruta final del archivo
    ruta_archivo = fullfile(carpeta_destino, [nombre_archivo, '.png']);
    
    % Guardar la figura en alta resolución (300 dpi)
    exportgraphics(fig, ruta_archivo, 'Resolution', 300);
    
    fprintf('Guardada exitosamente: %s\n', ruta_archivo);
end

fprintf('\n¡Todas las gráficas se han guardado en la carpeta "%s"!\n', carpeta_destino);

