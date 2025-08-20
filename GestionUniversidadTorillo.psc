Algoritmo Universidad
	Dimension materias[10], alumnos[10], profesores[10], materiaProfesor[10], listaMaterias[10]
	Dimension inscripciones[10,10], notas[10,10]
	Dimension usuarios[30], contraseñas[30], roles[30]  // roles: 1=Admin,2=Profesor,3=Alumno
	
	Definir rolActual, idUsuario, idMateria, idProfesor, idModificar, idProfesorActual, idAlumnoActual, nota, cont, cant  Como Entero
	Definir totalMaterias, totalAlumnos, totalProfesores, totalUsuarios, principalSalir, op, encontrado, opcionModificar Como Entero
	Definir user, pass, nuevoNombre, nuevaMateria, nuevoAlumno, nuevoProfesor Como Cadena
	Definir suma, promedio Como Real
	
	totalUsuarios <- 0
	totalAlumnos <- 0
	totalProfesores <- 0
	totalMaterias <- 3	
	materias[1] <- "Programacion"
	materias[2] <- "Matematica"
	materias[3] <- "Algoritmos"
	totalUsuarios <- totalUsuarios + 1
	usuarios[totalUsuarios] <- "admin"
	contraseñas[totalUsuarios] <- "1234"
	roles[totalUsuarios] <- 1
	principalSalir <- 0
	encontrado <- 0
	
	Repetir
		repetir
			Escribir "Usuario (0 para salir del programa):"
			Leer user
			
			Si user = "0" Entonces
				principalSalir <- 1
			Sino
				Escribir "Contraseña:"
				Leer pass
				encontrado <- 0
				Para i <- 1 Hasta totalUsuarios
					Si usuarios[i] = user Y contraseñas[i] = pass Entonces
						encontrado <- 1
						rolActual <- roles[i]
						idUsuario <- i
					FinSi
				FinPara
				
				Si encontrado = 0 Entonces
					Escribir "Usuario o contraseña incorrectos."
				FinSi
			FinSi
		Hasta Que encontrado = 1 O principalSalir = 1
		
		Si principalSalir = 0 Entonces
			Segun rolActual Hacer
				1: // admin
					Repetir
						Escribir "=== Menu Administrador ==="
						Escribir "1. Crear materia"
						Escribir "2. Crear alumno"
						Escribir "3. Crear profesor"
						Escribir "4. Asignar profesor a materia"
						Escribir "5. Modificar Datos"
						Escribir "6. Ver estadisticas"
						Escribir "7. Salir"
						Leer op
						Limpiar Pantalla
						Segun op Hacer
							1:
								Si totalMaterias < 10 Entonces
									Escribir "Ingrese el nombre de la nueva materia:"
									Leer nuevaMateria
									totalMaterias <- totalMaterias + 1
									materias[totalMaterias] <- nuevaMateria
								SiNo
									Escribir "No se pueden agregar mas materias."
								FinSi
							2:
								Si totalAlumnos < 10 Entonces
									Escribir "Ingrese el nombre del nuevo alumno:"
									Leer nuevoAlumno
									totalAlumnos <- totalAlumnos + 1
									alumnos[totalAlumnos] <- nuevoAlumno
									totalUsuarios <- totalUsuarios + 1
									usuarios[totalUsuarios] <- nuevoAlumno
									Escribir "Defina contraseña para ", nuevoAlumno, ":"
									Leer pass
									contraseñas[totalUsuarios] <- pass
									roles[totalUsuarios] <- 3
									Escribir "Alumno creado con éxito."
								SiNo
									Escribir "No se pueden agregar más alumnos."
								FinSi
							3:
								Si totalProfesores < 10 Entonces
									Escribir "Ingrese el nombre del nuevo profesor:"
									Leer nuevoProfesor
									totalProfesores <- totalProfesores + 1
									profesores[totalProfesores] <- nuevoProfesor
									totalUsuarios <- totalUsuarios + 1
									usuarios[totalUsuarios] <- nuevoProfesor
									Escribir "Defina contraseña para ", nuevoProfesor, ":"
									Leer pass
									contraseñas[totalUsuarios] <- pass
									roles[totalUsuarios] <- 2
									Escribir "Profesor creado con éxito."
								SiNo
									Escribir "No se pueden agregar más profesores."
								FinSi
							4:
								Si totalMaterias > 0 Y totalProfesores > 0 Entonces
									Escribir "Seleccione la materia:"
									Para i<-1 Hasta totalMaterias Hacer
										Escribir i, ". ", materias[i]
									FinPara
									Leer idMateria
									Escribir "Seleccione el profesor:"
									Para i<-1 Hasta totalProfesores Hacer
										Escribir i, ". ", profesores[i]
									FinPara
									Leer idProfesor
									materiaProfesor[idMateria] <- idProfesor
									Escribir "Profesor asignado."
								SiNo
									Escribir "Debe crear materias y profesores primero."
								FinSi
							5: 
								Repetir
									Escribir "--- Submenú Modificar ---"
									Escribir "1. Cambiar nombre de Alumno"
									Escribir "2. Cambiar nombre de Materia"
									Escribir "3. Volver"
									Leer opcionModificar 
									Segun opcionModificar 
										1:
											Escribir "Seleccione el alumno a modificar:"
											Para i<-1 Hasta totalAlumnos Hacer
												Escribir i, ". ", alumnos[i]
											FinPara
											Leer idModificar
											Si idModificar>=1 y idModificar<=totalAlumnos Entonces
												Escribir "Ingrese el nuevo nombre para ", alumnos[idModificar], ":"
												Leer nuevoNombre
												alumnos[idModificar] <- nuevoNombre
												Escribir "Nombre actualizado."
											SiNo
												Escribir "Opción no válida."
											FinSi
										2:
											Escribir "Seleccione la materia a modificar:"
											Para i<-1 Hasta totalMaterias Hacer
												Escribir i, ". ", materias[i]
											FinPara
											Leer idModificar
											Si idModificar>=1 y idModificar<=totalMaterias Entonces
												Escribir "Ingrese el nuevo nombre para ", materias[idModificar], ":"
												Leer nuevoNombre
												materias[idModificar] <- nuevoNombre
												Escribir "Nombre actualizado."
											SiNo
												Escribir "Opción no válida."
											FinSi
									FinSegun
									Si opcionModificar <> 3 Entonces 
										Esperar Tecla
										Limpiar Pantalla
									FinSi
								Hasta Que opcionModificar = 3 
							6:
								Escribir "=== Estadisticas ==="
								Para j<-1 Hasta totalMaterias Hacer
									cont <- 0
									Para i<-1 Hasta totalAlumnos Hacer
										Si inscripciones[i,j] = 1 Entonces
											cont <- cont + 1
										FinSi
									FinPara
									Escribir materias[j], ": ", cont, " alumnos."
								FinPara
							7:
								Escribir "Volviendo al menu principal..."
						FinSegun
						Si op < 7 y op <> 5 entonces
							Esperar Tecla
							Limpiar Pantalla
						FinSi
						Si op = 5 Entonces
							Limpiar Pantalla
						FinSi
					Hasta Que op=7
					
				2: // prof
					idProfesorActual <- 0 
					Para i <- 1 Hasta totalProfesores
						Si profesores[i] = user Entonces
							idProfesorActual <- i
						FinSi
					FinPara
					
					Repetir
						Escribir "=== Menu Profesor - ", user, " ==="
						Escribir "1. Cargar notas"
						Escribir "2. Ver mis materias (con promedios)"
						Escribir "3. Volver"
						Leer op
						Limpiar Pantalla
						
						Segun op Hacer
							1: 
								cont <- 0
								Para i <- 1 Hasta totalMaterias
									Si materiaProfesor[i] = idProfesorActual Entonces
										cont <- cont + 1
										listaMaterias[cont] <- i
									FinSi
								FinPara
								Si cont = 0 Entonces
									Escribir "No tiene materias asignadas."
								SiNo
									Escribir "Seleccione materia para cargar notas:"
									Para i <- 1 Hasta cont
										Escribir i, ". ", materias[listaMaterias[i]]
									FinPara
									Leer opcionMateria
									idMateria <- listaMaterias[opcionMateria]
									Escribir "Alumnos inscriptos en ", materias[idMateria], ":"
									Para i <- 1 Hasta totalAlumnos
										Si inscripciones[i,idMateria] = 1 Entonces
											Escribir "Ingrese nota para ", alumnos[i], ":"
											Leer nota
											notas[i,idMateria] <- nota
										FinSi
									FinPara
								FinSi
								
							2: 
								cont <- 0
								Para i <- 1 Hasta totalMaterias
									Si materiaProfesor[i] = idProfesorActual Entonces
										cont <- cont + 1
										listaMaterias[cont] <- i
									FinSi
								FinPara
								Si cont = 0 Entonces
									Escribir "No tiene materias asignadas."
								SiNo
									Escribir "Seleccione materia para ver alumnos:"
									Para i <- 1 Hasta cont
										Escribir i, ". ", materias[listaMaterias[i]]
									FinPara
									Leer opcionMateria
									idMateria <- listaMaterias[opcionMateria]
									
									Escribir "--- Alumnos en ", materias[idMateria], " ---"
									suma <- 0
									cant <- 0
									Para i <- 1 Hasta totalAlumnos
										Si inscripciones[i,idMateria] = 1 Entonces
											Escribir " - ", alumnos[i], " - Nota: "
											Si notas[i,idMateria] <> 0 Entonces
												Escribir Sin Saltar, notas[i,idMateria]
												Escribir ""
												suma <- suma + notas[i,idMateria] 
												cant <- cant + 1                  
											SiNo
												Escribir Sin Saltar, "(sin nota)"
												Escribir ""
											FinSi
										FinSi
									FinPara
									Si cant > 0 Entonces
										promedio <- suma / cant
										Escribir "---------------------------------"
										Escribir "Promedio de la materia: ", promedio
										Escribir "---------------------------------"
									SiNo
										Escribir "No hay alumnos con notas cargadas en esta materia."
									FinSi
								FinSi
							3:
								Escribir "Volviendo al menu principal..."
						FinSegun
						Esperar Tecla
						Limpiar Pantalla
					Hasta Que op = 3
				3: // alumn
					idAlumnoActual <- 0 
					Para i <- 1 Hasta totalAlumnos
						Si alumnos[i] = user Entonces
							idAlumnoActual <- i
						FinSi
					FinPara
					
					Repetir
						Escribir "=== Menu Estudiante - ", user," ==="
						Escribir "1. Inscribirse en materia"
						Escribir "2. Ver mis notas y promedio" 
						Escribir "3. Volver"
						Leer op
						Limpiar Pantalla
						Segun op Hacer
							1: 
								Escribir "Materias disponibles:"
								Para i<-1 Hasta totalMaterias Hacer
									Escribir i, ". ", materias[i]
								FinPara
								Escribir "Seleccione materia para inscribirse:"
								Leer idMateria
								inscripciones[idAlumnoActual,idMateria] <- 1
								Escribir "Inscripción exitosa."
								
							2: 
								Escribir "--- Tus Notas ---"
								suma <- 0
								cant <- 0
								Para j<-1 Hasta totalMaterias Hacer
									Si inscripciones[idAlumnoActual,j] = 1 Entonces
										Escribir materias[j], ": "
										Si notas[idAlumnoActual,j] <> 0 Entonces
											Escribir "    Nota: ", notas[idAlumnoActual,j]
											suma <- suma + notas[idAlumnoActual,j] 
											cant <- cant + 1                 
										SiNo
											Escribir "    (sin nota cargada)"
										FinSi
									FinSi
								FinPara
								Si cant > 0 Entonces
									promedio <- suma / cant
									Escribir "---------------------------------"
									Escribir "Tu promedio general: ", promedio
									Escribir "---------------------------------"
								SiNo
									Escribir "Aún no tienes notas cargadas."
								FinSi
							3:
								Escribir "Volviendo al menu principal..."
						FinSegun
						Esperar Tecla
						Limpiar Pantalla
					Hasta Que op=3
			FinSegun
		FinSi
	Hasta Que principalSalir = 1
FinAlgoritmo