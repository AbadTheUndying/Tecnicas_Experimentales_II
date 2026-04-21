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

% SUGERENCIAS
% - Intentar añadir una estimación teórica de las rectas para así confirmar
%   el comportamiento.
% - Estimación de la densidad lineal de las cuerdas con las mediciones.

n_metal = [1, 2, 3, 4, 5]; 
f_metal = [34.5, 68.3, 102.6, 136.7, 170.9];

n_cobre = [1, 2, 3, 4, 5];
f_cobre = [43.4, 84.4, 126.2, 169.6, 215.5];

err_f = 0.1; % Error instrumental del generador de funciones + Error en apreciciación de la resonancia
f_err_metal = err_f * ones(size(f_metal));
f_err_cobre = err_f * ones(size(f_cobre));

p_metal = polyfit(n_metal, f_metal, 1);
p_cobre = polyfit(n_cobre, f_cobre, 1);

figure('Name', 'Modos Normales', 'Color', 'w', 'Position', [100, 100, 700, 500]);
hold on; grid on; box on;

% Representacion con barras de error
errorbar(n_metal, f_metal, f_err_metal, 'bo', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k', 'MarkerSize', 8, 'LineStyle', 'none', 'DisplayName', 'Datos exp. (Hierro)');
plot(n_metal, polyval(p_metal, n_metal), 'b--', 'DisplayName', sprintf('Ajuste Hierro (f = %.1f n)', p_metal(1)));

errorbar(n_cobre, f_cobre, f_err_cobre, 'rs', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k', 'MarkerSize', 8, 'LineStyle', 'none', 'DisplayName', 'Datos exp. (Cobre)');
plot(n_cobre, polyval(p_cobre, n_cobre), 'r-', 'DisplayName', sprintf('Ajuste Cobre (f = %.1f n)', p_cobre(1)));

xlabel('Numero de modo normal (n)');
ylabel('Frecuencia de resonancia f_{n} (Hz)');
title('Relacion Lineal: Frecuencia vs Modo Normal');
legend('Location', 'northwest');
xlim([0, 6]); ylim([0, 250]);


%% ========================================================================
% 2. ESTUDIO DEL AMORTIGUAMIENTO (CUERDA DE COBRE)
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

disp('--- RESULTADOS DEL FACTOR DE CALIDAD (Q) ---');
for i = 1:4
    f_raw = freqs{i};
    v_raw = volts{i};
    
    f_dense = linspace(min(f_raw), max(f_raw), 1000);
    v_spline = spline(f_raw, v_raw, f_dense);
    
    [V_max, idx_max] = max(v_spline);
    f0 = f_dense(idx_max);
    
    V_half = V_max / sqrt(2);
    idx_left = find(v_spline(1:idx_max) <= V_half, 1, 'last');
    idx_right = find(v_spline(idx_max:end) <= V_half, 1, 'first') + idx_max - 1;
    
    delta_f = f_dense(idx_right) - f_dense(idx_left);
    Q = f0 / delta_f;
    
    fprintf('%s -> f0 = %.3f Hz | Delta_f = %.3f Hz | Q = %.1f\n', plot_labels{i}, f0, delta_f, Q);
    
    f_centrado = f_dense - f0; 
    
    % Dibujamos la curva suave
    plot(f_centrado, v_spline, '-', 'Color', colores(i,:), 'DisplayName', sprintf('%s (Q = %.0f)', plot_labels{i}, Q));
    
    % SUSTITUCIÓN: Usamos errorbar para los puntos experimentales con errores en X e Y
    err_Y = err_V_pico * ones(size(v_raw));
    err_X = err_f_gen * ones(size(f_raw));
    
    errorbar(f_raw - f0, v_raw, err_Y, err_Y, err_X, err_X, 'o', 'Color', colores(i,:), ...
        'MarkerFaceColor', colores(i,:), 'MarkerSize', 5, 'LineStyle', 'none', 'HandleVisibility', 'off'); 
end

xlabel('Desplazamiento de frecuencia \Delta f = f - f_{0} (Hz)');
ylabel('Voltaje inducido V_{rms} (mV)');
title('Curvas de Resonancia Centradas: Efecto de la Resistencia');
legend('Location', 'northeast');
xlim([-0.3, 0.3]); 


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
% 4. RECONSTRUCCIÓN DE LA AMPLITUD MECÁNICA (TEORÍA VS EXPERIMENTO)
% ========================================================================
% Según la sección 3.5 del Fundamento Teórico: V_max es proporcional a A*omega.
% Por tanto, la amplitud mecánica relativa es A_rel = V / (2 * pi * f).

% Usaremos los datos de R = 100 Ohms como ejemplo representativo
f_R100 = [41.50, 41.55, 41.60, 41.65, 41.70, 41.75, 41.80, 41.85, 41.90, 41.95, ...
          42.00, 42.05, 42.10, 42.15, 42.20, 42.25, 42.30, 42.35, 42.40, 42.45, ...
          42.47, 42.48, 42.50, 42.55, 42.60, 42.65, 42.70];
V_R100 = [2.0, 2.0, 2.0, 2.0, 2.0, 3.0, 3.0, 3.0, 3.0, 4.0, ...
          5.0, 7.0, 9.0, 11.0, 15.0, 16.0, 21.0, 25.0, 29.0, 6.0, ...
          5.0, 5.0, 5.0, 4.0, 3.0, 3.0, 2.0];

% Calculamos la amplitud mecánica relativa
omega = 2 * pi * f_R100;
Amplitud_relativa = V_R100 ./ omega;

% Normalizamos para que el máximo sea 1 (facilita la visualización del perfil)
Amplitud_norm = Amplitud_relativa / max(Amplitud_relativa);
V_norm = V_R100 / max(V_R100);

figure('Name', 'Reconstruccion Amplitud', 'Color', 'w', 'Position', [250, 250, 700, 500]);
hold on; grid on; box on;

% Interpolaciones suaves para mejor visualización
f_fit = linspace(min(f_R100), max(f_R100), 1000);
A_fit = spline(f_R100, Amplitud_norm, f_fit);
V_fit = spline(f_R100, V_norm, f_fit);

% Dibujamos Voltaje vs Amplitud Reconstruida
plot(f_fit, V_fit, 'b-', 'DisplayName', 'Señal Eléctrica (V_{rms} normalizado)');
plot(f_fit, A_fit, 'r-', 'DisplayName', 'Amplitud Mecánica Reconstruida (A normalizada)');

% Marcamos los puntos experimentales
scatter(f_R100, V_norm, 30, 'b', 'filled', 'HandleVisibility', 'off');
scatter(f_R100, Amplitud_norm, 30, 'r', 's', 'filled', 'HandleVisibility', 'off');

xlabel('Frecuencia de excitacion f (Hz)');
ylabel('Respuesta Normalizada (Adimensional)');
title('Comparativa: Señal Eléctrica vs Amplitud Mecánica Reconstruida');
legend('Location', 'northwest');

% --- Análisis del desplazamiento del pico ---
[~, idx_V] = max(V_fit);
[~, idx_A] = max(A_fit);
f_res_V = f_fit(idx_V);
f_res_A = f_fit(idx_A);

fprintf('\n--- RECONSTRUCCIÓN DE LA AMPLITUD MECÁNICA ---\n');
fprintf('Frecuencia de pico del Voltaje: %.3f Hz\n', f_res_V);
fprintf('Frecuencia de pico de la Amplitud Mecanica: %.3f Hz\n', f_res_A);
fprintf('Diferencia: %.3f Hz\n\n', f_res_V - f_res_A);

%% ========================================================================
% 5. AJUSTE TEORICO: LORENTZIANA (AJUSTE A LA SUBIDA LINEAL)
% ========================================================================

f_data = f_R100;
A_data = V_R100 ./ (2 * pi * f_data); % Amplitud mecanica relativa

% NORMALIZACION
A_max_real = max(A_data);
A_data_norm = A_data / A_max_real;

% ANCLAMOS LA FRECUENCIA DE RESONANCIA
[A_max_exp, idx_max] = max(A_data_norm);
f0_fijo = f_data(idx_max); 

% LA MAGIA: Filtramos los datos para ajustar SOLO la parte izquierda (subida)
% Esto evita que la caida asimetrica (no-linealidad) rompa el ajuste
f_left = f_data(1:idx_max);
A_left = A_data_norm(1:idx_max);

% Modelo teorico (f0 constante)
% x(1) = Amplitud neta, x(2) = Q, x(3) = Ruido de fondo (Offset)
modelo_fijo = @(x, f) x(3) + x(1) ./ sqrt(1 + 4 * x(2)^2 * ((f - f0_fijo)./f0_fijo).^2);

% Valores iniciales
offset_guess = min(A_data_norm); 
amp_guess = A_max_exp - offset_guess; 
Q_guess = 396; 

x0_fijo = [amp_guess, Q_guess, offset_guess]; 

% Ajuste no lineal (SOLO con f_left y A_left)
opciones = statset('nlinfit');
x_final = nlinfit(f_left, A_left, modelo_fijo, x0_fijo, opciones);

% Resultados del ajuste
A_max_fit = x_final(1);
Q_teorico = x_final(2);
ruido_fondo = x_final(3);

figure('Name', 'Ajuste Teorico (Mitad Izquierda)', 'Color', 'w', 'Position', [300, 300, 700, 500]);
hold on; grid on; box on;

% Dibujamos la curva teorica COMPLETA para comparar
f_axis = linspace(min(f_data), max(f_data), 1000);
plot(f_axis, modelo_fijo(x_final, f_axis), 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Teoria Lineal (Q = %.0f)', Q_teorico));

% Puntos experimentales totales
err_A = (1.0 ./ (2 * pi * f_data)) / A_max_real; 
errorbar(f_data, A_data_norm, err_A, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 5, 'LineStyle', 'none', 'DisplayName', 'Datos Experimentales');

% Resaltamos los puntos usados para el ajuste
scatter(f_left, A_left, 40, 'b', 's', 'filled', 'DisplayName', 'Datos usados en el ajuste');

xlabel('Frecuencia f (Hz)');
ylabel('Amplitud Mecanica Normalizada');
title('Oscilador No Lineal vs Teoria Lineal Clasica');
legend('Location', 'northeast');
xlim([42.15, 42.6]); % Zoom al pico

fprintf('\n--- ANALISIS DEL AJUSTE TEORICO (SUBIDA) ---\n');
fprintf('Frecuencia de resonancia (Fijada): %.3f Hz\n', f0_fijo);
fprintf('Factor de calidad (Regimen Lineal): %.1f\n', Q_teorico);
fprintf('Ruido de fondo normalizado: %.3f\n\n', ruido_fondo);

%% ========================================================================
% 6. ANALISIS GLOBAL EN REGIMEN LINEAL (CORRECCION EFECTO DUFFING)
% ========================================================================
% Una vez demostrado el comportamiento no lineal en el apartado 5, 
% aplicamos el ajuste de "solo subida" (regimen lineal) a todas las 
% resistencias para obtener factores de calidad fisicamente realistas.

freqs = {f_R10, f_R100, f_R1000, f_tierra};
volts = {V_R10, V_R100, V_R1000, V_tierra};
plot_labels = {'R = 10 \Omega', 'R = 100 \Omega', 'R = 1000 \Omega', 'Tierra'};
colores = lines(4);

figure('Name', 'Ajustes Regimen Lineal (Subida)', 'Color', 'w', 'Position', [150, 150, 800, 550]);
hold on; grid on; box on;

fprintf('\n--- RESULTADOS DEL Q EN REGIMEN LINEAL (EXCLUYENDO DUFFING) ---\n');

Q_resultados = zeros(1, 4);

for i = 1:4
    f_data = freqs{i};
    % 1. Reconstruir amplitud relativa mecanica
    A_data = volts{i} ./ (2 * pi * f_data);
    
    % 2. Normalizar
    A_max_real = max(A_data);
    A_data_norm = A_data / A_max_real;
    
    % 3. Identificar el pico
    [A_max_exp, idx_max] = max(A_data_norm);
    f0_fijo = f_data(idx_max); 
    
    % 4. FILTRAR LA SUBIDA (Regimen Lineal)
    f_left = f_data(1:idx_max);
    A_left = A_data_norm(1:idx_max);
    
    % 5. Modelo Teorico (Ahora el offset es x(3), un parametro LIBRE)
    offset_guess = min(A_data_norm); 
    amp_guess = A_max_exp - offset_guess; 
    Q_guess = 180; % Estimacion mas cercana a la realidad
    
    modelo_fijo = @(x, f) x(3) + x(1) ./ sqrt(1 + 4 * x(2)^2 * ((f - f0_fijo)./f0_fijo).^2);
    x0_fijo = [amp_guess, Q_guess, offset_guess]; 
    
    % 6. Ajuste No Lineal
    opciones = statset('nlinfit'); 
    
    try
        x_final = nlinfit(f_left, A_left, modelo_fijo, x0_fijo, opciones);
        Q_fit = x_final(2);
        ruido_fit = x_final(3);
    catch
        Q_fit = NaN; 
    end
    
    Q_resultados(i) = Q_fit;
    fprintf('%s -> f0 = %.3f Hz | Q_lineal = %.1f\n', plot_labels{i}, f0_fijo, Q_fit);
    
    % 7. Graficar (Centrado en Delta f = 0 para poder compararlas bien)
    f_axis = linspace(min(f_data), max(f_data), 500);
    f_centrado = f_axis - f0_fijo;
    plot(f_centrado, modelo_fijo(x_final, f_axis), '-', 'Color', colores(i,:), 'LineWidth', 1.5, 'DisplayName', sprintf('%s (Q = %.0f)', plot_labels{i}, Q_fit));
    
    % Dibujar los puntos experimentales (tambien centrados)
    err_A = (1.0 ./ (2 * pi * f_data)) / A_max_real;
    errorbar(f_data - f0_fijo, A_data_norm, err_A, 'o', 'Color', colores(i,:), 'MarkerFaceColor', colores(i,:), 'MarkerSize', 5, 'LineStyle', 'none', 'HandleVisibility', 'off');
end

xlabel('Desplazamiento de frecuencia \Delta f = f - f_0 (Hz)');
ylabel('Amplitud Mecanica Normalizada');
title('Ajuste Global en Regimen Lineal (Efecto Duffing Excluido)');
legend('Location', 'northeast');
xlim([-0.4, 0.4]);



%% ========================================================================
% 7. DEMOSTRACIÓN DEL EFECTO DUFFING: FWHM vs REGIMEN LINEAL
% ========================================================================
% Usaremos R = 100 Ohms como caso representativo para ilustrar el problema

f_data = f_R100;
A_data = V_R100 ./ (2 * pi * f_data);
A_max_real = max(A_data);
A_data_norm = A_data / A_max_real;

% CÁLCULO CLÁSICO: Método FWHM (Ancho a Media Altura)
% Interpolamos para tener precisión en el corte
f_dense = linspace(min(f_data), max(f_data), 5000);
A_spline = spline(f_data, A_data_norm, f_dense);

[~, idx_max_spline] = max(A_spline);
f0_exp = f_dense(idx_max_spline);

% El corte de media potencia en amplitud es a 1/sqrt(2) = 0.707
nivel_FWHM = 1 / sqrt(2); 

idx_left = find(A_spline(1:idx_max_spline) <= nivel_FWHM, 1, 'last');
idx_right = find(A_spline(idx_max_spline:end) <= nivel_FWHM, 1, 'first') + idx_max_spline - 1;

f_left_FWHM = f_dense(idx_left);
f_right_FWHM = f_dense(idx_right);
delta_f_FWHM = f_right_FWHM - f_left_FWHM;

Q_FWHM = f0_exp / delta_f_FWHM;

% CÁLCULO CORREGIDO: Ajuste Lineal (Solo subida)
[~, idx_max_data] = max(A_data_norm);
f_left_data = f_data(1:idx_max_data);
A_left_data = A_data_norm(1:idx_max_data);

offset_guess = min(A_data_norm); 
modelo_fijo = @(x, f) x(3) + x(1) ./ sqrt(1 + 4 * x(2)^2 * ((f - f0_exp)./f0_exp).^2);
x0_fijo = [1 - offset_guess, 175, offset_guess]; 

opciones = statset('nlinfit'); 
x_final = nlinfit(f_left_data, A_left_data, modelo_fijo, x0_fijo, opciones);
Q_lineal = x_final(2);

% ========================================================================
% REPRESENTACIÓN GRÁFICA COMPARATIVA
% ========================================================================
figure('Name', 'Demostracion Duffing', 'Color', 'w', 'Position', [200, 200, 750, 550]);
hold on; grid on; box on;

% Curva suave de los datos
plot(f_dense, A_spline, 'k--', 'LineWidth', 1, 'HandleVisibility', 'off');

% Calculamos el error en Y (1 mV del osciloscopio escalado y normalizado)
err_A = (1.0 ./ (2 * pi * f_data)) / A_max_real;

% Puntos experimentales con barras de error
errorbar(f_data, A_data_norm, err_A, 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 6, 'LineStyle', 'none', 'DisplayName', 'Datos Exp. \pm Error');

% Curva del modelo lineal ideal
plot(f_dense, modelo_fijo(x_final, f_dense), 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Comportamiento Lineal Ideal (Q = %.0f)', Q_lineal));

% Marcamos el ancho FWHM (El error)
plot([f_left_FWHM, f_right_FWHM], [nivel_FWHM, nivel_FWHM], 'b-', 'LineWidth', 2.5, 'DisplayName', sprintf('Ancho FWHM Deformado (Q = %.0f)', Q_FWHM));
plot([f_left_FWHM, f_right_FWHM], [nivel_FWHM, nivel_FWHM], 'bo', 'MarkerFaceColor', 'b', 'HandleVisibility', 'off');

% Linea teórica de dónde debería estar el corte derecho si fuera lineal
f_right_ideal = f0_exp + (f0_exp - f_left_FWHM); % Asumiendo simetría perfecta
plot([f_right_FWHM, f_right_ideal], [nivel_FWHM, nivel_FWHM], 'r:', 'LineWidth', 2, 'DisplayName', 'Ancho Real "Oculto"');

xlabel('Frecuencia f (Hz)', 'FontSize', 12);
ylabel('Amplitud Mecanica Normalizada', 'FontSize', 12);
title('Impacto del Efecto Duffing en el Cálculo del Factor Q (R = 100 \Omega)', 'FontSize', 14);
legend('Location', 'northeast', 'FontSize', 11);
xlim([42.15, 42.6]);

fprintf('\n--- COMPARATIVA DE METODOS (Demostración Duffing) ---\n');
fprintf('Q Asumiendo linealidad (Método FWHM): %.1f\n', Q_FWHM);
fprintf('Q Real filtrando la no-linealidad: %.1f\n', Q_lineal);
fprintf('Error introducido por el efecto Duffing: +%.1f%%\n\n', ((Q_FWHM - Q_lineal)/Q_lineal)*100);

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